
# Meal-it

Meal-It busca ser un asistente diario para una alimentación más personalizada y basada en distintos tipos de rutina.

## Características

 - Sugerencia automática de una comida aleatoria diaria desde la API de TheMealDB.
 - Visualización del nombre, imagen, ingredientes e instrucciones de preparación.
 - Registro de actividad e interacción en la búsqueda de recetas.

## Funcionalidades

- Marcado de recetas como favoritas, con guardado persistente.

- Historial y galería de recetas guardadas.

- Toma de fotografías de los platos preparados para compartir o guardar.

- Personalización de menús según datos personales del usuario (como restricciones alimentarias, alergias o tipo de dieta).

- Integración con el área de salud del dispositivo (como Google Fit) para recomendaciones nutricionales personalizadas.

- Registro de hábitos y metas alimenticias.

## API utilizada – TheMealDB

- **URL base:** `https://www.themealdb.com/api/json/v1/1/`
- **Endpoint utilizado:** `random.php`
- **Ejemplo de consulta:**  
  `GET https://www.themealdb.com/api/json/v1/1/random.php`

### Respuesta simplificada:

```json
{
  "meals": [
    {
      "strMeal": "Spaghetti Carbonara",
      "strInstructions": "Bring a large pot of water to a boil...",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg",
      "strIngredient1": "Spaghetti",
      "strMeasure1": "200g"
    }
  ]
}
```


## Capturas de Pantalla

![image](https://github.com/user-attachments/assets/a2350ce3-d223-44be-a35d-d9d2277604c8)

![image](https://github.com/user-attachments/assets/6979807a-6b11-4a5f-87bc-0bdec9d5a2b5)

![image](https://github.com/user-attachments/assets/180175c8-0533-4c3e-bbd2-29518d1121cf)

![image](https://github.com/user-attachments/assets/113d23e6-9a7a-493f-a544-ac5ea41a0e74)


## Links 

