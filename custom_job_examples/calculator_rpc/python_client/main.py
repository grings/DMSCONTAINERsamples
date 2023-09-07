from calculatorrpc import CalculatorRPCProxy
proxy = CalculatorRPCProxy("https://localhost/calculatorrpc")
print("10 + 30 = ", proxy.sum(10,30))
print("20 - 5 = ", proxy.diff(20,5))

