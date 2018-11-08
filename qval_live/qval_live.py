from codeload.moonshot.qval import QuantitativeValue

class QuantitativeValueLive(QuantitativeValue):
    """
    Variant of qval strategy intended to be run with Sharadar fundamentals against 
    an IB history database.
    """
    CODE = "qval-live"
    DB = "nyse-stk-1d"
    UNIVERSES = "nyse-stk"
    EXCLUDE_UNIVERSES = ["nyse-financials", "nyse-adrs", "nyse-reits"]
    MASTER_DOMAIN = "main"
    CALENDAR = "NYSE"
    ALLOW_REBALANCE = 0.05 # only rebalance positions if they're changing by at least 5%
    
    def order_stubs_to_orders(self, orders, prices):
        orders["Exchange"] = "SMART"
        orders["OrderType"] = "MOC"
        orders["Tif"] = "DAY"
        return orders