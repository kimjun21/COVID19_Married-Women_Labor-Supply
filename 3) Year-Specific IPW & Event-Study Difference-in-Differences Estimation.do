**# Year-Specific IPW & Event-Study Difference-in-Differences Estimation #**

// 기본 모형 형태 - 코로나 전후 (2019 기준) 변화를 살피기 위해 연도별 IPW를 사용한 고차원 고정효과 Event Study-DiD 회귀모형 //

* reghdfe: 고차원 고정효과 (High-Dimensional Fixed Effects) 를 활용하여 개인·지역 고정효과 [absorb(개인id 지역)] 를 동시에 흡수함
* 통제변수: 연령, 연령제곱, 교육수준, 로그가처분소득, num_child_7to18
* [pw=ipw]: 연도별 역확률 가중치 적용함
* vce(cluster 개인id): 개인 수준 클러스터링으로 자기상관 및 이분산을 교정함

// 모형 내 핵심 추정치 - ib2019.year##i.자녀연령 //

* ib2019.year##i.자녀연령: 2019년을 기준 연도로 연도에 따른 미취학 자녀 유무별 유급노동시간의 변화를 추정함. 2020년도 × 자녀연령 상호작용항이 음의 계수를 가지고 통계적으로 유의미한 값을 가지는지를 검증함.


reghdfe 종속변수 ib2019.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 지역) vce(cluster 개인id)

