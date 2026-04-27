# Phase 4 Refactoring Plan

## Target: showConsumptionBilling() - Lines 2234-2648 (414 lines)

### Current Structure:
1. Container setup (lines 2235-2240)
2. Data validation (lines 2242-2291)
3. Metric filtering into primary/time-based (lines 2293-2321)
4. Primary metrics rendering (lines 2323-2372)
5. Time-based metrics rendering (lines 2375-2421)
6. Pricing calculator UI (lines 2423-2464)
7. Cost calculation function (inline, lines 2475-2631)
8. Chart rendering (lines 2633-2647)

### Extraction Strategy:
1. Extract `recalculateCloudCosts` inline function to top-level function
2. Extract metric filtering logic to `filterConsumptionMetrics(meteredData)`
3. Extract primary metrics rendering to `renderPrimaryMetrics(container, primaryMetrics)`
4. Extract time-based metrics rendering to `renderTimeBasedMetrics(container, timeMetrics)`
5. Extract pricing calculator UI to `renderCloudPricingCalculator(container)`
6. Keep orchestration in main function

This will reduce `showConsumptionBilling()` from 414 lines to ~100 lines.
