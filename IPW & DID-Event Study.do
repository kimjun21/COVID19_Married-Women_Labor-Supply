**# IPW & DID-Event Study #**

// 기본 모형 - 코로나 전후 (2019 기준) 변화를 살피기 위해 Event Study 기반의 DiD //

* reghdfe: 고차원 고정효과(High-Dimensional Fixed Effects) OLS를 활용한 DID-Event Study
* absorb(개인id 업종_더미 직종_더미 지역): 개인·업종·직종·지역 고정효과를 동시에 흡수함
* [pw=ipw]: 연도별 역확률 가중치 적용함
* vce(cluster 개인id): 개인 수준 클러스터링으로 자기상관 및 이분산을 교정함
* 통제변수: 연령, 연령제곱, 교육수준, 로그가처분소득, num_child_7to18 등

// 모형 내 핵심 추정치 //

* ib2019.year##i.자녀연령: 연도 × 미취학 자녀 유무 상호작용항으로 2019년을 기준 연도로 연도에 따라 미취학 자녀 유무별 유급노동시간의 변화를 추정함

reghdfe 종속변수 ib2019.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 업종_더미 직종_더미 지역) vce(cluster 개인id)
