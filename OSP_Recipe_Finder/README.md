# OSP Recipe Finder

OSP Recipe Finder is a simple recipe recommendation system written in Jac language. It demonstrates how to model recipes, ingredients, and people, and how to find recipes based on available ingredients and skill level.

## Features
- Defines nodes for `Recipe`, `Ingredient`, and `Person`.
- Uses edges to represent relationships (e.g., which ingredients a recipe uses, which ingredients a person has).
- Includes a `RecipeFinder` walker that suggests recipes a person can make based on their skill level and available ingredients.
- Example data for two people (Thiru and TonyStark) and two recipes.

## How to Run
1. Make sure you have Jac installed. See: https://jac-lang.com/docs/getting-started
2. In your terminal, navigate to the project directory:
   ```sh
   cd /Users/thiru-07/Downloads/Jac_OSP
   ```
3. Run the Jac file:
   ```sh
   jac run main.jac
   ```

## Output
The script will print out which recipes each person can make, based on their skill level and the ingredients they have.

## Customization
- Add more recipes, ingredients, or people by editing `main.jac`.
- Adjust skill levels or recipe difficulties to see different results.

## License
This project is for educational/demo purposes.
