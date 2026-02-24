**# 사례수
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* ---- IPW 전(무가중) 집단별 N ----
count if `treat'==1
local N_pre_T = r(N)

count if `treat'==0
local N_pre_C = r(N)

* ---- IPW 후(가중) 집단별 사례수(∑w) ----
quietly summarize w_norm if `treat'==1, meanonly
local N_post_T = r(sum)

quietly summarize w_norm if `treat'==0, meanonly
local N_post_C = r(sum)

display "IPW 전  처치 N = `N_pre_T'   비교 N = `N_pre_C'"
display "IPW 후  처치 N = " %12.2f `N_post_T' "   비교 N = " %12.2f `N_post_C'

restore

**# 연령
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 연령, over(`treat')

* IPW 후(가중)
mean 연령 [pw=w_norm], over(`treat')

restore

**# 연령제곱
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 연령제곱, over(`treat')

* IPW 후(가중)
mean 연령제곱 [pw=w_norm], over(`treat')

restore

**# 교육수준 (고졸이하)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 교육수준_더미1, over(`treat')

* IPW 후(가중)
mean 교육수준_더미1 [pw=w_norm], over(`treat')

restore

**# 교육수준 (전문대졸)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 교육수준_더미2, over(`treat')

* IPW 후(가중)
mean 교육수준_더미2 [pw=w_norm], over(`treat')

restore

**# 교육수준 (대졸)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 교육수준_더미3, over(`treat')

* IPW 후(가중)
mean 교육수준_더미3 [pw=w_norm], over(`treat')

restore

**# 교육수준 (대학원졸)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 교육수준_더미4, over(`treat')

* IPW 후(가중)
mean 교육수준_더미4 [pw=w_norm], over(`treat')

restore

**# 로그가처분소득
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 로그가처분소득, over(`treat')

* IPW 후(가중)
mean 로그가처분소득 [pw=w_norm], over(`treat')

restore

**# 초중고 학령기 자녀 수
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean num_child_7to18, over(`treat')

* IPW 후(가중)
mean num_child_7to18  [pw=w_norm], over(`treat')

restore

**# 지역 (서울)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미1, over(`treat')

* IPW 후(가중)
mean 지역_더미1  [pw=w_norm], over(`treat')

restore

**# 지역 (인천/경기)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미2, over(`treat')

* IPW 후(가중)
mean 지역_더미2  [pw=w_norm], over(`treat')

restore

**# 지역 (부산/경남/울산)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미3, over(`treat')

* IPW 후(가중)
mean 지역_더미3  [pw=w_norm], over(`treat')

restore

**# 지역 (대구/경북)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미4, over(`treat')

* IPW 후(가중)
mean 지역_더미4  [pw=w_norm], over(`treat')

restore

**# 지역 (대전/충남)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미5, over(`treat')

* IPW 후(가중)
mean 지역_더미5  [pw=w_norm], over(`treat')

restore

**# 지역 (강원/충북)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미6, over(`treat')

* IPW 후(가중)
mean 지역_더미6  [pw=w_norm], over(`treat')

restore

**# 지역 (광주/전남/전북/제주도)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* 결측 제거: treat, wgt, xlist 중 하나라도 결측이면 해당 관측치를 drop
egen byte miss = rowmiss(`treat' `wgt' `xlist')
keep if miss==0
drop miss

* 정규화: IPW 사례수(∑w)를 표본크기 N으로 정규화
count
local N = r(N)
quietly summarize `wgt', meanonly
gen double w_norm = `wgt' * (`N' / r(sum))

* IPW 전(무가중)
mean 지역_더미7, over(`treat')

* IPW 후(가중)
mean 지역_더미7  [pw=w_norm], over(`treat')

restore

**# SMD
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016
local covs  연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1-지역_더미7

* 가중치 정리: 가중치가 결측치 또는 음수라면 삭제함. 
drop if missing(`wgt') | `wgt'<=0

* treat 변수 확인: treat 변수가 두 그룹으로 구성되는지 확인함.
quietly levelsof `treat', local(levs)
if wordcount("`levs'") != 2 {
    di as error "`treat' 는 두 그룹으로 구성되어야 합니다."
    error 198
}
local g0 : word 1 of `levs'
local g1 : word 2 of `levs'

tempvar T
gen byte `T' = .
replace `T' = 0 if `treat'==`g0'
replace `T' = 1 if `treat'==`g1'
keep if inlist(`T',0,1)

tempfile smd2016
postfile handle str40 var ///
    double m1_w m0_w v1_w v0_w smd_w ///
    double m1_u m0_u v1_u v0_u smd_u ///
    using "`smd2016'", replace

foreach var of varlist `covs' {

    *-----------------------
    * (1) IPW 후: weighted
    *-----------------------
    quietly mean `var' [pw=`wgt'], over(`T')
    matrix MW = r(table)
    scalar m0_w = MW[1,1]
    scalar m1_w = MW[1,2]

    tempvar wx wx2
    quietly gen double `wx'  = `wgt'*`var'
    quietly gen double `wx2' = `wgt'*(`var'^2)

    quietly summarize `wx'  if `T'==0 & !missing(`var'), meanonly
    scalar sx0 = r(sum)
    quietly summarize `wgt' if `T'==0 & !missing(`var'), meanonly
    scalar sw0 = r(sum)
    quietly summarize `wx2' if `T'==0 & !missing(`var'), meanonly
    scalar ss0 = r(sum)
    scalar v0_w = ss0/sw0 - (sx0/sw0)^2

    quietly summarize `wx'  if `T'==1 & !missing(`var'), meanonly
    scalar sx1 = r(sum)
    quietly summarize `wgt' if `T'==1 & !missing(`var'), meanonly
    scalar sw1 = r(sum)
    quietly summarize `wx2' if `T'==1 & !missing(`var'), meanonly
    scalar ss1 = r(sum)
    scalar v1_w = ss1/sw1 - (sx1/sw1)^2

    scalar smd_w = (m1_w - m0_w) / sqrt((v1_w+v0_w)/2)

    drop `wx' `wx2'

    *-----------------------
    * (2) IPW 전: unweighted
    *-----------------------
    quietly mean `var', over(`T')
    matrix MU = r(table)
    scalar m0_u = MU[1,1]
    scalar m1_u = MU[1,2]

    quietly summarize `var' if `T'==0
    scalar v0_u = r(Var)
    quietly summarize `var' if `T'==1
    scalar v1_u = r(Var)

    scalar smd_u = (m1_u - m0_u) / sqrt((v1_u+v0_u)/2)

    post handle ("`var'") ///
        (m1_w) (m0_w) (v1_w) (v0_w) (smd_w) ///
        (m1_u) (m0_u) (v1_u) (v0_u) (smd_u)
}
postclose handle

use "`smd2016'", clear
gen abs_smd_w = abs(smd_w)
gen abs_smd_u = abs(smd_u)

list var smd_u abs_smd_u smd_w abs_smd_w, noobs abbreviate(24)

save smd2016, replace
restore