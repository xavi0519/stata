#include <iostream>
#include <iomanip>

using namespace std;

int main() {
    int n;
    double pesos[100];

    cout << "Ingrese la cantidad de paquetes: ";
    cin >> n;

    if (n < 1 || n > 100) {
        cout << "Cantidad invalida. Debe ser un entero positivo entre 1 y 100." << endl;
    }
    else {
        int i = 0;
        while (i < n) {
            cout << "Ingrese el peso del paquete " << (i + 1) << " (kg): ";
            cin >> pesos[i];

            if (pesos[i] <= 0) {
                cout << "Peso invalido. Debe ser un numero real positivo." << endl;
            }
            else {
                i++;
            }
        }

        double minimo = pesos[0];
        double maximo = pesos[0];
        double suma = 0.0;

        int j = 0;
        while (j < n) {
            if (pesos[j] < minimo) {
                minimo = pesos[j];
            }
            if (pesos[j] > maximo) {
                maximo = pesos[j];
            }
            suma = suma + pesos[j];
            j++;
        }

        double promedio = suma / n;

        // Ordenamiento burbuja de menor a mayor
        int k = 0;
        while (k < n - 1) {
            int l = 0;
            while (l < n - 1 - k) {
                if (pesos[l] > pesos[l + 1]) {
                    double temp = pesos[l];
                    pesos[l] = pesos[l + 1];
                    pesos[l + 1] = temp;
                }
                l++;
            }
            k++;
        }

        cout << fixed << setprecision(2);
        cout << endl;
        cout << "--- RESUMEN DE PESOS ---" << endl;
        cout << "Minimo: " << minimo << " kg" << endl;
        cout << "Maximo: " << maximo << " kg" << endl;
        cout << "Cantidad: " << n << " paquetes" << endl;
        cout << "Promedio: " << promedio << " kg" << endl;
        cout << endl;
        cout << "Pesos ordenados (menor a mayor):" << endl;

        int m = 0;
        while (m < n) {
            if (m < n - 1) {
                cout << pesos[m] << " ";
            }
            else {
                cout << pesos[m];
            }
            m++;
        }
        cout << endl;
    }

    return 0;
}
