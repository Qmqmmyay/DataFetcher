from vnstock import Vnstock

def get_symbols_by_exchange(exchange):
    stock = Vnstock().stock(symbol='VNINDEX', source='VCI')
    symbols = stock.listing.symbols_by_exchange()
    symbols = symbols[(symbols['exchange'] == exchange) & (symbols['type'] == 'STOCK')]
    return sorted(symbols.symbol.to_list())

# 📈 Pull all listed symbols at initialization time
HOSE_SYMBOLS = get_symbols_by_exchange('HSX')
HNX_SYMBOLS = get_symbols_by_exchange('HNX')
UPCOM_SYMBOLS = get_symbols_by_exchange('UPCOM')
