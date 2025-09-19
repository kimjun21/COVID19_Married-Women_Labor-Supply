**# year-specific inverse probability weights #**

gen ipw = .

foreach y in 2016 2017 2018 2019 2020 2021 {

    preserve
    display "==== `y'년 성향점수, overlap 확인 및 Stabilized IPW 추정 중 ===="
    keep if year == `y'

    * 연도마다 공변량에 대한 성향점수를 로짓으로 추정함
    logit 자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
	      업종1 업종2 업종3 업종4 업종5 업종6 업종7 ///
	      직종1 직종2 직종3 직종4 직종5 직종6 직종7 ///
          지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

    predict pscore_`y', pr

    * teffects ipw: 성향점수를 기반으로 한 IPW 추정을 실행 → 처치 효과(기본값: ATE) 추정
	* osample(overlap_flag): overlap 조건을 확인하고, 문제가 있는 표본을 자동으로 표시 → 추정이 신뢰할 수 있도록
	* capture noisily: 반복 추정 중 특정 표본 문제(공통지지 위반, 결측 등)로 에러가 나도 명령문 실행이 멈추지 않게
    capture noisily teffects ipw (종속변수) ///
        (자녀연령 = 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
	     업종1 업종2 업종3 업종4 업종5 업종6 업종7 ///
	     직종1 직종2 직종3 직종4 직종5 직종6 직종7 ///
         지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7), osample(overlap_flag)

    * overlap 조건 확인 및 overlap 조건 위반 제거
    capture confirm variable overlap_flag
    if !_rc {
        keep if overlap_flag != 1
    }

	* trimming: 데이터의 실제 분포에 맞춰 자동으로 1~99 분위수 구간을 잡음
    quietly _pctile pscore_`y', p(1 99)
    local lb = r(r1)
    local ub = r(r2)

    display ">> Trimming 범위 (`y'): `lb' ~ `ub'"

    * trimming 연도별로 적용
    keep if pscore_`y' > `lb' & pscore_`y' < `ub'

    * 전체 표본에서 자녀연령(=1)의 비율 계산
    quietly sum 자녀연령
    local pt = r(mean)          // 미취학 자녀가 있는 기혼 여성 비율
    local pc = 1 - `pt'         // 미취학 자녀가 없는 기혼 여성 비율

    * 안정화된 ipw 연도별로 계산
	* 일반 ipw는 처치를 받을 수 있는 사람들 중에서 실제로 처치를 받은 사람들의 역수
	* 안정화된 ipw는 일반 ipw에 전체 표본 중 처치를 받은 사람의 비율을 곱함
    gen ipw_`y' = .
    replace ipw_`y' = `pt' / pscore_`y' if 자녀연령 == 1
    replace ipw_`y' = `pc' / (1 - pscore_`y') if 자녀연령 == 0

    * 성향점수 & 가중치 연도별로 저장
    keep 개인id year ipw_`y' pscore_`y'
    tempfile ipwfile_`y'
    save `ipwfile_`y''
    restore
}

* -----------------------
* 연도별로 병합 (pscore, ipw 함께)
* -----------------------
foreach y in 2016 2017 2018 2019 2020 2021 {
    merge 1:1 개인id year using `ipwfile_`y'', nogen
}

* -----------------------
* 최종 ipw 변수 생성
* -----------------------
foreach y in 2016 2017 2018 2019 2020 2021 {
    replace ipw = ipw_`y' if year == `y'
}

