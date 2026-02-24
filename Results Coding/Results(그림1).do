**# IPW 전 (complete-case only)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016

* 공변량 목록 (결측 없어야 하는 변수들)
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* === 핵심: pscore, treat, wgt, xlist 중 하나라도 결측이면 drop ===
egen byte miss = rowmiss(pscore_2016 `treat' `wgt' `xlist')
keep if miss==0
drop miss

* --- common support 구간 계산 (겹치는 pscore 범위) ---
quietly summarize pscore_2016 if `treat'==1, meanonly
local tmin = r(min)
local tmax = r(max)

quietly summarize pscore_2016 if `treat'==0, meanonly
local cmin = r(min)
local cmax = r(max)

local cs_lo = max(`tmin', `cmin')
local cs_hi = min(`tmax', `cmax')

* --- note에 쓸 문자열 (포맷 적용) ---
local cs_lo_s : display %6.3f `cs_lo'
local cs_hi_s : display %6.3f `cs_hi'

* --- 시각화 ---
twoway ///
 (histogram pscore_2016 if `treat'==1, width(.02) start(0) ///
    fraction fcolor(red%30) lcolor(red)) ///
 (histogram pscore_2016 if `treat'==0, width(.02) start(0) ///
    fraction fcolor(blue%30) lcolor(blue)) ///
 , ///
 xscale(range(0 1)) ///
 xline(`cs_lo' `cs_hi', lcolor(gs8) lpattern(shortdash)) ///
 legend(order(1 "Treatment" 2 "Control") ring(5) pos(12) col(2)) ///
 title("Common Support: Pscore Overlap (2016)") ///
 xtitle("Propensity Score") ytitle("Proportion") ///
 note("* Note: Common Support = [`cs_lo_s', `cs_hi_s']") ///
 name(g_cs_hist, replace)

restore

**# IPW 후 (complete-case + IPW-weighted overlap)
preserve
keep if year==2016

local treat 자녀연령
local wgt   ipw_2016

* 공변량 목록 (결측 없어야 하는 변수들)
local xlist 연령 연령제곱 교육수준 로그가처분소득 num_child_7to18 ///
            지역_더미1 지역_더미2 지역_더미3 지역_더미4 지역_더미5 지역_더미6 지역_더미7

* === 핵심: pscore, treat, wgt, xlist 중 하나라도 결측이면 drop ===
egen byte miss = rowmiss(pscore_2016 `treat' `wgt' `xlist')
keep if miss==0
drop miss


* --- IPW 반영 common support 구간 계산 (가중 1~99 분위수 겹침) ---
local wplot `wgt'

_pctile pscore_2016 [aw=`wplot'] if `treat'==1, p(1 99)
local tlo = r(r1)
local thi = r(r2)

_pctile pscore_2016 [aw=`wplot'] if `treat'==0, p(1 99)
local clo = r(r1)
local chi = r(r2)

local cs_lo = max(`tlo', `clo')
local cs_hi = min(`thi', `chi')

* --- note에 쓸 문자열 (포맷 적용) ---
local cs_lo_s : display %6.3f `cs_lo'
local cs_hi_s : display %6.3f `cs_hi'

* IPW-weighted "histogram": bin별 가중치합 → 가중 비중 → bar로 그림
local bw    = .05
local start = 0

tempvar bin wt_treat wt_ctrl
gen int `bin' = floor((pscore_2016-`start')/`bw')
replace `bin' = . if missing(pscore_2016)

* [0,1] 범위 밖(혹은 마지막 bin 초과) 정리
keep if `bin' >= 0 & `bin' <= floor((1-`start')/`bw')

* bin 가운데값 (막대의 x좌표)
gen double bin_mid = `start' + (`bin'+0.5)*`bw'

* 집단별 bin 가중치합
gen double `wt_treat' = `wplot' if `treat'==1
gen double `wt_ctrl'  = `wplot' if `treat'==0

collapse (sum) wt_treat=`wt_treat' wt_ctrl=`wt_ctrl', by(bin_mid)

* 집단 내 가중 비중 (= weighted proportion)
quietly summarize wt_treat, meanonly
local S1 = r(sum)
quietly summarize wt_ctrl, meanonly
local S0 = r(sum)

gen double prop_treat = wt_treat/`S1'
gen double prop_ctrl  = wt_ctrl/`S0'

* --- 시각화 ---
twoway ///
 (bar prop_treat bin_mid, barwidth(`bw') fcolor(red%30) lcolor(red)) ///
 (bar prop_ctrl  bin_mid, barwidth(`bw') fcolor(blue%30) lcolor(blue)) ///
 , ///
 xscale(range(0 1)) ///
 xline(`cs_lo' `cs_hi', lcolor(gs8) lpattern(shortdash)) ///
 legend(order(1 "Treatment (IPW)" 2 "Control (IPW)") ring(5) pos(12) col(2)) ///
 title("Common Support: IPW-Weighted Pscore Overlap (2016)") ///
 xtitle("Propensity Score") ytitle("Weighted Proportion") ///
 note("* Note: Common Support (IPW, 1st–99th percentiles) = [`cs_lo_s', `cs_hi_s']") ///
 name(g_cs_hist_ipw, replace)

restore