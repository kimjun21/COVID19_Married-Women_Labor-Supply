**# Placebo Test #**

* 기준연도 (2019년) 의 이전 연도 (2018 ~ 2016) 에 대해 가짜 기준연도 (placebo year) 를 설정하는 방식임
* 3) Year-Specific IPW & Event-Study Difference-in-Differences Estimation (2019년도 기준연도) 에서 구한 2020년도 × 자녀연령의 상호작용항이 음의 계수를 가지고 통계적으로 유의미하다면 아래의 1 ~ 3번이 성립해야 그에 대한 강건성을 입증함

** 가짜 기준연도 2018, Placebo Test -> 2019년도 × 자녀연령의 상호작용항의 계수가 통계적으로 유의미하지 않아야 함!
reghdfe 종속변수 ib2018.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 지역) vce(cluster 개인id)

** 가짜 기준연도 2017, Placebo Test -> 2018년도 × 자녀연령의 상호작용항의 계수가 통계적으로 유의미하지 않아야 함!
reghdfe 종속변수 ib2017.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 지역) vce(cluster 개인id)

** 가짜 기준연도 2016, Placebo Test -> 2017년도 × 자녀연령의 상호작용항의 계수가 통계적으로 유의미하지 않아야 함!
reghdfe 종속변수 ib2016.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 지역) vce(cluster 개인id)