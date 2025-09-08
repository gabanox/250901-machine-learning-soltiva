# [Reto] Ejercicio Python para Machine Learning

## Información general del laboratorio

Este es un laboratorio de desafío diseñado para evaluar y fortalecer sus habilidades en Python aplicadas a Machine Learning. En lugar de seguir instrucciones paso a paso, se le presentarán problemas reales que debe resolver usando Python, pandas, numpy y scikit-learn en un entorno de AWS.

El reto consiste en analizar un conjunto de datos de ventas de una empresa, realizar análisis exploratorio de datos (EDA), crear modelos predictivos y generar insights accionables para el negocio.

## Objetivos del reto

Al completar este reto, habrá demostrado su capacidad para:

- Manipular y limpiar datos usando pandas
- Realizar análisis exploratorio de datos (EDA)
- Crear visualizaciones informativas
- Implementar modelos de Machine Learning
- Evaluar y optimizar modelos
- Generar insights de negocio basados en datos
- Trabajar con APIs y servicios web
- Manejar datos en tiempo real

## Duración

El tiempo estimado para completar este reto es de **40 minutos**.

## Configuración del entorno

### Tarea 1: Conectarse a la instancia EC2

1. En la **Consola de administración de AWS**, navegue a **EC2**.

2. Seleccione la instancia llamada **Python ML Lab Instance**.

3. Conéctese usando **EC2 Instance Connect** o SSH.

4. Una vez conectado, verifique las herramientas instaladas:
   ```bash
   python3 --version
   pip3 list | grep -E "(pandas|numpy|scikit-learn|matplotlib|seaborn)"
   ```

## Escenario del reto

Usted es un Data Scientist en "TechRetail Corp", una empresa de comercio electrónico. El equipo de negocio necesita insights sobre el comportamiento de compra de los clientes para optimizar las estrategias de marketing y ventas.

Se le han proporcionado datos históricos de transacciones y debe:

1. **Limpiar y preparar** los datos para análisis
2. **Realizar EDA** para entender patrones de compra
3. **Crear modelos predictivos** para segmentación de clientes
4. **Predecir el valor de vida del cliente** (Customer Lifetime Value)
5. **Generar recomendaciones** basadas en análisis

## Datos disponibles

### Dataset principal: `sales_data.csv`

```csv
customer_id,transaction_date,product_category,product_name,quantity,unit_price,total_amount,customer_age,customer_gender,customer_location,marketing_channel
CUST001,2024-01-15,Electronics,Smartphone,1,699.99,699.99,28,M,New York,Online
CUST002,2024-01-15,Clothing,T-Shirt,3,25.99,77.97,34,F,California,Email
CUST003,2024-01-16,Electronics,Laptop,1,1299.99,1299.99,42,M,Texas,Social Media
```

### Dataset complementario: `customer_support.csv`

```csv
customer_id,support_tickets,avg_resolution_time,satisfaction_score,last_contact_date
CUST001,2,24,4.5,2024-01-10
CUST002,0,0,5.0,2024-01-01
CUST003,1,12,4.8,2024-01-12
```

## Retos a resolver

### Reto 1: Análisis Exploratorio de Datos (EDA)
**Tiempo estimado: 15 minutos**

Cree un notebook Jupyter o script Python que responda:

1. **Análisis básico**:
   - ¿Cuántas transacciones únicas hay en el dataset?
   - ¿Cuál es el rango de fechas de los datos?
   - ¿Cuántos clientes únicos tenemos?

2. **Análisis de ventas**:
   - ¿Cuáles son los top 5 productos más vendidos?
   - ¿Qué categoría genera más ingresos?
   - ¿Cuál es la distribución de montos de transacción?

3. **Análisis de clientes**:
   - ¿Cuál es la distribución por edad y género?
   - ¿Qué canal de marketing es más efectivo?
   - ¿Cuál es el ticket promedio por cliente?

**Código de inicio**:

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime, timedelta
import warnings
warnings.filterwarnings('ignore')

# Configurar estilo de gráficos
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

# Cargar datos
def load_data():
    """
    Cargar y preparar los datasets
    """
    # TODO: Implementar carga de datos
    # Puede simular datos si no tiene acceso a archivos reales
    pass

def basic_eda(df):
    """
    Realizar análisis exploratorio básico
    """
    print("=== ANÁLISIS EXPLORATORIO DE DATOS ===\n")
    
    # TODO: Implementar análisis básico
    # - Información general del dataset
    # - Estadísticas descriptivas
    # - Valores faltantes
    # - Distribuciones principales
    
    pass

# Ejecutar análisis
df_sales = load_data()
basic_eda(df_sales)
```

### Reto 2: Segmentación de Clientes con RFM
**Tiempo estimado: 15 minutos**

Implemente un análisis RFM (Recency, Frequency, Monetary) para segmentar clientes:

1. **Calcule métricas RFM**:
   - **Recency**: Días desde la última compra
   - **Frequency**: Número total de transacciones
   - **Monetary**: Valor total de compras

2. **Cree segmentos de clientes**:
   - Champions (R: 4-5, F: 4-5, M: 4-5)
   - Loyal Customers (R: 2-5, F: 3-5, M: 3-5)
   - Potential Loyalists (R: 3-5, F: 1-3, M: 1-3)
   - At Risk (R: 1-2, F: 2-5, M: 2-5)
   - Lost Customers (R: 1-2, F: 1-2, M: 1-2)

3. **Analice los segmentos**:
   - Tamaño de cada segmento
   - Valor promedio por segmento
   - Características demográficas

**Código de inicio**:

```python
def calculate_rfm(df):
    """
    Calcular métricas RFM para cada cliente
    """
    # Fecha de referencia (última fecha en los datos + 1 día)
    reference_date = df['transaction_date'].max() + timedelta(days=1)
    
    rfm = df.groupby('customer_id').agg({
        'transaction_date': lambda x: (reference_date - x.max()).days,  # Recency
        'customer_id': 'count',  # Frequency
        'total_amount': 'sum'    # Monetary
    }).reset_index()
    
    rfm.columns = ['customer_id', 'recency', 'frequency', 'monetary']
    
    # TODO: Implementar scoring RFM (1-5 para cada métrica)
    # TODO: Crear segmentos basados en scores RFM
    
    return rfm

def create_customer_segments(rfm_df):
    """
    Crear segmentos de clientes basados en RFM
    """
    # TODO: Implementar lógica de segmentación
    # TODO: Asignar nombres de segmentos
    # TODO: Calcular estadísticas por segmento
    
    pass

# Ejecutar segmentación RFM
rfm_analysis = calculate_rfm(df_sales)
segments = create_customer_segments(rfm_analysis)
```

### Reto 3: Modelo Predictivo de Customer Lifetime Value
**Tiempo estimado: 10 minutos**

Cree un modelo para predecir el CLV (Customer Lifetime Value):

1. **Prepare las características**:
   - Métricas RFM
   - Datos demográficos
   - Historial de soporte
   - Canal de adquisición

2. **Entrene un modelo**:
   - Use Random Forest o Gradient Boosting
   - Divida en train/test (80/20)
   - Evalúe con MAE, RMSE y R²

3. **Genere predicciones**:
   - CLV para próximos 12 meses
   - Identifique clientes de alto valor
   - Ranking de clientes por CLV predicho

**Código de inicio**:

```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.preprocessing import LabelEncoder, StandardScaler

def prepare_features_for_clv(df_sales, df_support):
    """
    Preparar características para modelo CLV
    """
    # TODO: Crear características agregadas por cliente
    # TODO: Combinar con datos de soporte
    # TODO: Codificar variables categóricas
    # TODO: Manejar valores faltantes
    
    pass

def train_clv_model(features_df, target_col='clv_12_months'):
    """
    Entrenar modelo de predicción CLV
    """
    # Separar características y target
    X = features_df.drop([target_col, 'customer_id'], axis=1)
    y = features_df[target_col]
    
    # División train/test
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )
    
    # TODO: Entrenar modelo
    # TODO: Evaluar rendimiento
    # TODO: Analizar importancia de características
    
    return model, X_test, y_test

# Ejecutar modelado CLV
features = prepare_features_for_clv(df_sales, df_support)
clv_model, X_test, y_test = train_clv_model(features)
```

## Retos adicionales (Opcionales)

### Reto 4: Detección de Anomalías

Implemente un sistema para detectar transacciones anómalas:

```python
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler

def detect_anomalies(df):
    """
    Detectar transacciones anómalas
    """
    # TODO: Preparar características numéricas
    # TODO: Usar Isolation Forest
    # TODO: Identificar patrones en anomalías
    
    pass
```

### Reto 5: Sistema de Recomendaciones

Cree un sistema básico de recomendación de productos:

```python
from sklearn.metrics.pairwise import cosine_similarity

def create_product_recommendations(df):
    """
    Sistema de recomendaciones basado en colaborative filtering
    """
    # TODO: Crear matriz customer-product
    # TODO: Calcular similitudes
    # TODO: Generar recomendaciones
    
    pass
```

### Reto 6: API de Predicciones

Cree una API simple usando Flask para servir predicciones:

```python
from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

# Cargar modelo entrenado
model = joblib.load('clv_model.pkl')

@app.route('/predict_clv', methods=['POST'])
def predict_clv():
    """
    API endpoint para predicción CLV
    """
    # TODO: Procesar request JSON
    # TODO: Hacer predicción
    # TODO: Retornar resultado
    
    pass

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

## Criterios de evaluación

Su solución será evaluada en base a:

### Calidad del código (30%)
- ✅ Código limpio y bien documentado
- ✅ Uso apropiado de librerías de Python
- ✅ Manejo adecuado de errores
- ✅ Estructura lógica y modular

### Análisis de datos (25%)
- ✅ EDA completo y revelador
- ✅ Visualizaciones claras e informativas
- ✅ Interpretación correcta de resultados
- ✅ Identificación de patrones relevantes

### Modelado (25%)
- ✅ Preparación adecuada de datos
- ✅ Selección apropiada de algoritmos
- ✅ Evaluación rigurosa de modelos
- ✅ Interpretación de resultados

### Insights de negocio (20%)
- ✅ Recomendaciones accionables
- ✅ Comunicación clara de hallazgos
- ✅ Conexión entre análisis y valor de negocio
- ✅ Consideración de limitaciones y próximos pasos

## Datos sintéticos para pruebas

Si no tiene acceso a datos reales, use este código para generar datos sintéticos:

```python
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

def generate_synthetic_data(n_customers=1000, n_transactions=5000):
    """
    Generar datos sintéticos para el reto
    """
    np.random.seed(42)
    
    # Generar clientes
    customers = []
    for i in range(n_customers):
        customers.append({
            'customer_id': f'CUST{i:04d}',
            'customer_age': np.random.randint(18, 70),
            'customer_gender': np.random.choice(['M', 'F']),
            'customer_location': np.random.choice(['New York', 'California', 'Texas', 'Florida', 'Illinois']),
            'marketing_channel': np.random.choice(['Online', 'Email', 'Social Media', 'Referral', 'Direct'])
        })
    
    # Generar transacciones
    products = [
        ('Electronics', 'Smartphone', 699.99),
        ('Electronics', 'Laptop', 1299.99),
        ('Electronics', 'Tablet', 399.99),
        ('Clothing', 'T-Shirt', 25.99),
        ('Clothing', 'Jeans', 79.99),
        ('Home', 'Coffee Maker', 149.99),
        ('Books', 'Python Guide', 39.99),
        ('Sports', 'Running Shoes', 129.99)
    ]
    
    transactions = []
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2024, 1, 31)
    
    for _ in range(n_transactions):
        customer = np.random.choice(customers)
        category, product, base_price = np.random.choice(products)
        quantity = np.random.randint(1, 5)
        unit_price = base_price * np.random.uniform(0.8, 1.2)  # Variación de precio
        
        transactions.append({
            'customer_id': customer['customer_id'],
            'transaction_date': start_date + timedelta(
                days=np.random.randint(0, (end_date - start_date).days)
            ),
            'product_category': category,
            'product_name': product,
            'quantity': quantity,
            'unit_price': round(unit_price, 2),
            'total_amount': round(quantity * unit_price, 2),
            'customer_age': customer['customer_age'],
            'customer_gender': customer['customer_gender'],
            'customer_location': customer['customer_location'],
            'marketing_channel': customer['marketing_channel']
        })
    
    return pd.DataFrame(transactions)

# Generar datos sintéticos
df_sales = generate_synthetic_data()
print(f"Dataset generado: {len(df_sales)} transacciones")
print(df_sales.head())
```

## Entrega del reto

Para completar el reto, debe entregar:

1. **Notebook Jupyter** o scripts Python con todo el análisis
2. **Visualizaciones** claras y profesionales
3. **Modelos entrenados** guardados con joblib/pickle
4. **Reporte ejecutivo** (1-2 páginas) con insights clave
5. **Código de API** (si implementó el reto adicional)

## Consejos para el éxito

- 📊 **Visualice todo**: Los gráficos comunican mejor que las tablas
- 🧹 **Limpie los datos**: Dedique tiempo a entender y limpiar los datos
- 🎯 **Enfóquese en el negocio**: Conecte cada análisis con valor comercial
- ⚡ **Itere rápidamente**: Haga análisis básico primero, refine después
- 📝 **Documente todo**: Explique su razonamiento y decisiones
- 🧪 **Valide resultados**: Use múltiples métricas y técnicas de validación

## Recursos de apoyo

- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Scikit-learn User Guide](https://scikit-learn.org/stable/user_guide.html)
- [Matplotlib Tutorials](https://matplotlib.org/stable/tutorials/index.html)
- [Seaborn Gallery](https://seaborn.pydata.org/examples/index.html)

---

**¡Buena suerte con el reto!** 🐍🚀

Este ejercicio le permitirá demostrar sus habilidades en Python y Machine Learning aplicadas a problemas reales de negocio.
