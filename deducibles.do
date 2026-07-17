#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

// --- FUNCIONES DE VALIDACION ---

bool ingreso_es_valido(double ingreso) {
    if (cin.fail()) {
        cout << "Error: Dato incorrecto. Ingrese un numero." << endl;
        cin.clear();
        cin.ignore(1000, '\n');
        return false;
    }
    else if (ingreso < 0) {
        cout << "Error: El ingreso nominal no puede ser negativo." << endl;
        return false;
    }
    else {
        return true;
    }
}

bool inflacion_es_valida(double inflacion) {
    if (cin.fail()) {
        cout << "Error: Dato incorrecto. Ingrese un numero." << endl;
        cin.clear();
        cin.ignore(1000, '\n');
        return false;
    }
    else if (inflacion < 0) {
        // Asumimos que la inflacion acumulada del ejercicio no debe ser negativa
        cout << "Error: La inflacion no debe ser negativa para este modelo." << endl;
        return false;
    }
    else {
        return true;
    }
}

// --- FUNCION PRINCIPAL ---

int main()
{
    // 1. Declaracion de constantes para la matriz
    const int cantidadTiendas = 4;
    const int cantidadMeses = 6;

    // 2. Declaracion de matrices y arreglos
    double ingresosNominales[cantidadTiendas][cantidadMeses]{ 0.0 };
    double ingresosReales[cantidadTiendas][cantidadMeses]{ 0.0 };
    double inflacion[cantidadMeses]{ 0.0 };

    // Arreglos para almacenar los calculos por cada tienda
    double crecRealProm[cantidadTiendas]{ 0.0 };
    double crecNomTotal[cantidadTiendas]{ 0.0 };
    double crecRealTotal[cantidadTiendas]{ 0.0 };
    double erosion[cantidadTiendas]{ 0.0 };

    // 3. Ingreso de Datos
    cout << "------ INGRESO DE DATOS ------" << endl << endl;
    cout << "[Ingresos nominales (4 tiendas, 6 meses) ]:" << endl;

    for (int i = 0; i < cantidadTiendas; i++) {
        cout << "Tienda " << (i + 1) << ": ";
        for (int j = 0; j < cantidadMeses; j++) {
            do {
                cin >> ingresosNominales[i][j];
            } while (!ingreso_es_valido(ingresosNominales[i][j]));
        }
    }

    cout << endl;
    cout << "[Inflacion acumulada por mes (% respecto al mes 1)]:" << endl;
    cout << "Inflacion por mes: ";
    for (int j = 0; j < cantidadMeses; j++) {
        do {
            cin >> inflacion[j];
        } while (!inflacion_es_valida(inflacion[j]));
    }

    // 4. Procesamiento de Calculos (Aplicando formulas)
    for (int i = 0; i < cantidadTiendas; i++) {
        for (int j = 0; j < cantidadMeses; j++) {
            // Ingreso a precios del mes 1 (Deflactacion)
            ingresosReales[i][j] = ingresosNominales[i][j] / (1.0 + (inflacion[j] / 100.0));
        }

        // Crecimiento real promedio mensual (Media geometrica)
        // Usamos la funcion pow() de <cmath>. Elevamos a (1/5) que es 0.2
        crecRealProm[i] = (pow((ingresosReales[i][5] / ingresosReales[i][0]), 0.2) - 1.0) * 100.0;

        // Crecimiento nominal total (%)
        crecNomTotal[i] = ((ingresosNominales[i][5] / ingresosNominales[i][0]) - 1.0) * 100.0;

        // Crecimiento real total (%)
        crecRealTotal[i] = ((ingresosReales[i][5] / ingresosReales[i][0]) - 1.0) * 100.0;

        // Erosion inflacionaria
        erosion[i] = crecNomTotal[i] - crecRealTotal[i];
    }

    // 5. Encontrar los indices de los valores mayores y menores
    int indiceMayorCrecRealProm = 0;
    int indiceMayorCrecNomTotal = 0;
    int indiceMayorCrecRealTotal = 0;
    int indiceMenorErosion = 0;

    for (int i = 1; i < cantidadTiendas; i++) {
        // Mayor crecimiento real promedio
        if (crecRealProm[i] > crecRealProm[indiceMayorCrecRealProm]) {
            indiceMayorCrecRealProm = i;
        }

        // Mayor crecimiento nominal
        if (crecNomTotal[i] > crecNomTotal[indiceMayorCrecNomTotal]) {
            indiceMayorCrecNomTotal = i;
        }

        // Mayor crecimiento real
        if (crecRealTotal[i] > crecRealTotal[indiceMayorCrecRealTotal]) {
            indiceMayorCrecRealTotal = i;
        }

        // Menor erosion (el menos afectado)
        if (erosion[i] < erosion[indiceMenorErosion]) {
            indiceMenorErosion = i;
        }
    }

    // 6. Impresion de Resultados
    cout << endl;
    cout << "------ RESUMEN FINANCIERO ------" << endl << endl;

    // Fijamos a 2 decimales
    cout << fixed << setprecision(2);

    cout << "Ingresos reales (precios del mes 1):" << endl;
    for (int i = 0; i < cantidadTiendas; i++) {
        cout << "Tienda " << (i + 1) << ":";
        for (int j = 0; j < cantidadMeses; j++) {
            // Utilizamos setw(10) para separar las columnas
            cout << setw(10) << ingresosReales[i][j];
        }
        cout << endl;
    }
    cout << endl;

    cout << "Crecimiento real promedio mensual (%):" << endl;
    for (int i = 0; i < cantidadTiendas; i++) {
        cout << "Tienda " << (i + 1) << ": " << crecRealProm[i] << "%";
        if (i == indiceMayorCrecRealProm) {
            cout << " (mayor crecimiento promedio real)";
        }
        cout << endl;
    }
    cout << endl;

    cout << "Crecimiento nominal total (%):" << endl;
    for (int i = 0; i < cantidadTiendas; i++) {
        cout << "Tienda " << (i + 1) << ": " << crecNomTotal[i] << "%";
        if (i == indiceMayorCrecNomTotal) {
            cout << " (mayor crecimiento nominal)";
        }
        cout << endl;
    }
    cout << endl;

    cout << "Crecimiento real total (%):" << endl;
    for (int i = 0; i < cantidadTiendas; i++) {
        cout << "Tienda " << (i + 1) << ": " << crecRealTotal[i] << "%";
        if (i == indiceMayorCrecRealTotal) {
            cout << " (mayor crecimiento real)";
        }
        cout << endl;
    }
    cout << endl;

    cout << "Erosion inflacionaria (%):" << endl;
    for (int i = 0; i < cantidadTiendas; i++) {
        cout << "Tienda " << (i + 1) << ": " << erosion[i] << "%";
        if (i == indiceMenorErosion) {
            cout << " (el menos afectado por el indice de precios)";
        }
        cout << endl;
    }

    return 0;
}
