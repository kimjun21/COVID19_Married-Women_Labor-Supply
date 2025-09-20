**# Placebo Test #**

* 기준연도(2019년)를 앞당겨서 가짜 기준연도(placebo year)를 설정하는 방식임
* 코로나19의 영향이 2019년 이후에만 나타난다면, 2018, 2017, 2016을 가짜 기준연도로 설정했을 때 연도와 자녀연령의 상호작용항이 통계적으로 유의미하지 않아야 함 -> 공통추세 가정 성립
* 가짜 기준연도 Placebo Test에서 연도와 자녀연령의 상호작용항에서 통계적으로 유의미한 효과가 나타난다면, IPW & DID-Event Study의 추정치는 코로나19의 영향이 아닌 다른 교란요인에 영향을 받았을 수 있음-> 공통추세 가정 비성립

* 가짜 기준연도 2018 Placebo Test
reghdfe 종속변수 ib2018.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 업종_더미 직종_더미 지역) vce(cluster 개인id)

* 가짜 기준연도 2017 Placebo Test
reghdfe 종속변수 ib2017.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 업종_더미 직종_더미 지역) vce(cluster 개인id)

* 가짜 기준연도 2016 Placebo Test
reghdfe 종속변수 ib2016.year##i.자녀연령 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 if inrange(year,2016,2021) [pw=ipw], absorb(개인id 업종_더미 직종_더미 지역) vce(cluster 개인id)