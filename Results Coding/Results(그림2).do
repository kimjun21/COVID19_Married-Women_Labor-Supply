**# Year-Specific Inverse Probability Weighting

gen ipw = .

foreach y in 2016 2017 2018 2019 2020 2021 {

    preserve
    display "==== `y'년 성향점수, overlap 확인 및 Stabilized IPW 추정 중 ===="
    keep if year == `y'

    * 연도별로 공변량에 대한 성향점수를 로짓으로 추정함
    logit 자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
          지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

    predict pscore_`y', pr

    * teffects ipw: 성향점수를 기반으로 IPW 추정을 실행 → 처치 효과 (기본값: ATE) 추정
	* osample(overlap_flag): overlap 조건을 확인하고, 문제가 있는 표본을 자동으로 표시 → 추정이 신뢰할 수 있도록
	* capture noisily: 메크로에서 특정 표본 문제(공통지지 위반, 결측 등)로 에러가 나도 명령문 실행이 멈추지 않게
    capture noisily teffects ipw (종속변수) ///
        (자녀연령 = 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
         지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7), osample(overlap_flag)

    * overlap 조건 확인 & overlap 조건 위반 제거
    capture confirm variable overlap_flag
    if !_rc {
        keep if overlap_flag != 1
    }

	* trimming: 데이터의 실제 성향점수 분포에 맞춰 자동으로 1~99 분위수 구간을 잡음
    quietly _pctile pscore_`y', p(1 99)
    local lb = r(r1)
    local ub = r(r2)

    display ">> Trimming 범위 (`y'): `lb' ~ `ub'"

    * trimming을 연도별로 적용
    keep if pscore_`y' > `lb' & pscore_`y' < `ub'

    * 전체 표본에서 자녀연령(=1)의 비율 계산
    quietly sum 자녀연령
    local pt = r(mean)          // 미취학 자녀가 있는 기혼 여성 비율
    local pc = 1 - `pt'         // 미취학 자녀가 없는 기혼 여성 비율

    * 안정화된 ipw를 연도별로 계산
	* 안정화된 ipw: 일반 ipw(처치를 받을 수 있는 사람들 중에서 실제로 처치를 받은 사람들의 역수)에 전체 표본 중 처치를 받은 사람의 비율을 곱함
	* Tip! 일반 ipw는 극단적인 성향점수가 있으면 가중치가 엄청 커져서 분산이 커지는 단점이 있음! 이를 안정화된 ipw는 조정할 수 있음!
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
* 최종 ipw 생성 완료
* -----------------------
foreach y in 2016 2017 2018 2019 2020 2021 {
    replace ipw = ipw_`y' if year == `y'
}

**# Year-Specific IPW & Event-Study Difference-in-Differences Estimation
reghdfe 종속변수 ib2019.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 지역) vce(cluster 개인id)

**# 그림 2
* EV 추정치 저장하기
estimates store EV

* EV 불러오고 계수 뽑기
estimates restore EV
local df = e(df_r)
parmest, norestore

* 관심 계수만
keep if inlist(parm, ///
    "2016.year#1.자녀연령", ///
    "2017.year#1.자녀연령", ///
    "2018.year#1.자녀연령", ///
    "2020.year#1.자녀연령", ///
    "2021.year#1.자녀연령")

* 연도 변수
gen year = .
replace year = 2016 if parm=="2016.year#1.자녀연령"
replace year = 2017 if parm=="2017.year#1.자녀연령"
replace year = 2018 if parm=="2018.year#1.자녀연령"
replace year = 2020 if parm=="2020.year#1.자녀연령"
replace year = 2021 if parm=="2021.year#1.자녀연령"
sort year

* 99% CI만 계산(라벨은 계수만 쓸 거라 pval/tstat 불필요)
local tcrit = invttail(`df', 0.005)
gen double lb = estimate - `tcrit'*stderr
gen double ub = estimate + `tcrit'*stderr

* 라벨(계수만)
gen str20 lbl = string(estimate, "%6.3f")

* baseline(2019=0) 추가
expand 2 in 1
replace year     = 2019 in L
replace estimate = 0    in L
replace lb       = .    in L
replace ub       = .    in L
replace lbl      = "baseline" in L
sort year
gen byte base = (year==2019)

* --- 시각화 ---
twoway ///
  (rcap ub lb year if base==0, lcolor(pink%50) lwidth(med)) ///
  (connected estimate year, lcolor(blue%30) lwidth(med) msymbol(none)) ///  
  (scatter estimate year if base==0, msymbol(O) mcolor(blue) msize(medlarge) ///
      mlabel(lbl) mlabsize(small) mlabcolor(blue) mlabposition(12) mlabgap(2)) ///
  (scatter estimate year if base==1, msymbol(O) mcolor(black) msize(medlarge) ///
      mlabel(lbl) mlabsize(small) mlabcolor(black) mlabposition(6) mlabgap(2)) ///
, ///
  yline(0, lpattern(dot) lwidth(med) lcolor(gs8)) ///
  xline(2019, lpattern(solid) lcolor(gs8) lwidth(med)) ///
  title("Event-Study DiD Estimation") ///
  xtitle("Year") ytitle("Hours of Paid Work") ///
  xscale(range(2015.5 2021.5)) ///
  yscale(range(-25 25)) ///
  xlabel(2016 "2016" 2017 "2017" 2018 "2018" 2019 "2019" 2020 "2020" 2021 "2021", nogrid) ///
  ylabel(, nogrid) ///
  legend( ///
      order(3 "Point Estimate" 1 "99% CI") ///
      rows(1) col(2) ///
      pos(6) ring(1) ///
      region(lcolor(black) fcolor(white) lwidth(thin) margin(small)) ///
      size(small) ///
  ) ///
  graphregion(color(white)) plotregion(margin(zero))

restore