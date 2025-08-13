from vnstock import Vnstock

def get_symbols_by_exchange(exchange):
    stock = Vnstock().stock(symbol='VNINDEX', source='VCI')
    symbols = stock.listing.symbols_by_exchange()
    symbols = symbols[(symbols['exchange'] == exchange) & (symbols['type'] == 'STOCK')]
    return sorted(symbols.symbol.to_list())

def get_all_hose_symbols():
    """Return all HOSE symbols - alias for backward compatibility"""
    return get_symbols_by_exchange('HSX')

# 📈 Pull all listed symbols at initialization time
HOSE_SYMBOLS = get_symbols_by_exchange('HSX')
HNX_SYMBOLS = get_symbols_by_exchange('HNX')
UPCOM_SYMBOLS = get_symbols_by_exchange('UPCOM')
