class Credito:
    def __init__(self, monto, plazo, interes):
        self.monto = monto
        self.plazo = plazo
        self.interes = interes


class CreditoFrances(Credito):
    def __init__(self, monto, plazo, interes):
        super().__init__(monto, plazo, interes)

    def amortizacion(self):
        # Cálculo de la cuota según la fórmula de amortización del crédito francés
        cuota = (self.monto * (self.interes/12) /
                 (1 - (1 + (self.interes/12)) ** -self.plazo))
        return cuota


def main():
    import math
    # Crear una instancia de la clase CreditoFrances
    mi_creditofran = CreditoFrances(120000000, 60, 0.12)
    # Llamar al método amortizacion e imprimir el resultado
    print(math.ceil(mi_creditofran.amortizacion()))


if __name__ == "__main__":
    main()
