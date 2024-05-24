import math


class Credito:
    def __init__(self, monto, plazo, interes):
        self.monto = monto
        self.plazo = plazo
        self.interes = interes


class CreditoFrances(Credito):
    def __constructfran__(self, monto, plazo, interes):
        super().__init__(monto, plazo, interes)

    def amortizacion(self):
        # Cálculo de la cuota según la fórmula de amortización del crédito francés
        cuota = (self.monto * (self.interes/12) /
                 (1 - (1 + (self.interes/12)) ** -self.plazo))
        return cuota


class CreditoAleman(Credito):
    def __constructale___(self, monto, plazo, interes):
        super().__init__(monto, plazo, interes)

    def amortizacion(self):
        """
        Calcula la amortización del préstamo utilizando el método de amortización alemán.

        :return: Una lista de las cuotas amortizadas para cada período.
        :rtype: list[int]
        """
        cuotas_amortizadas = []
        cuota_capital = self.monto / self.plazo
        saldo = self.monto
        for self.plazo in range(self.plazo):
            interes = saldo * self.interes / 12
            cuota_total = int(cuota_capital + interes)
            cuotas_amortizadas.append(cuota_total)
            saldo -= cuota_capital
        return cuotas_amortizadas


def main():
    # Crear una instancia de la clase credito_frances
    mi_creditofran = CreditoFrances(120000000, 60, 0.12)
    # Llamar al método amortizacion e imprimir el resultado
    print(math.ceil(mi_creditofran.amortizacion()))

    # Crear una instancia de la clase credito_aleman
    mi_creditoale = CreditoAleman(120000000, 60, 0.12)
    print(mi_creditoale.amortizacion())


if __name__ == "__main__":
    main()
