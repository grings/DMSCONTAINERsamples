from calculatorrpc import CalculatorRPCProxy
proxy = CalculatorRPCProxy("https://localhost/calculatorrpc")
print(proxy.sum(10,30))



