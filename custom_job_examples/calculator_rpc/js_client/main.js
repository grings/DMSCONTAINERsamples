import { CalculatorRPCProxy } from "./calculator_proxy.js";
const init = () => {
    document.querySelector('#btnCalculate').onclick = () => {
        let proxy = new CalculatorRPCProxy("https://localhost/calculatorrpc");
        let op1 = parseFloat(document.querySelector("#op1").value);
        let op2 = parseFloat(document.querySelector("#op2").value);
        proxy.sum(op1, op2).then(res => {
            document.querySelector("#res").value = res;
        });
    }
}

export {init};