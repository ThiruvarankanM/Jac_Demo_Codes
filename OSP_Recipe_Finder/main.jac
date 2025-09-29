node Recipe {
    has name: str;
    has cuisine: str;
    has difficulty: int;
    has prep_time: int;
}

node Ingredient {
    has name: str;
    has category: str;
}

node Person {
    has name: str;
    has skill_level: int;
}

edge Uses {
    has amount: str;
    has required: bool;
}

edge HasIngredient {}

walker RecipeFinder {
    can find_recipes with Person entry {
        print(f"=== Recipe Finder for {here.name} ===");
        print(f"Skill Level: {here.skill_level}");
        
        my_ingredients = [here->:HasIngredient:->(`?Ingredient)];
        print("Available ingredients:");
        for ing in my_ingredients {
            print(f"  - {ing.name}");
        }
        
        all_recipes = [root-->(`?Recipe)];
        print(f"\nChecking {len(all_recipes)} recipes:");
        
        for recipe in all_recipes {
            if recipe.difficulty > here.skill_level {
                print(f"✗ {recipe.name} - Too difficult (level {recipe.difficulty})");
                continue;
            }
            
            required_ingredients = [recipe->:Uses:required == True:->(`?Ingredient)];
            can_make = True;
            
            for req_ing in required_ingredients {
                has_ingredient = False;
                for my_ing in my_ingredients {
                    if my_ing.name == req_ing.name {
                        has_ingredient = True;
                        break;
                    }
                }
                if not has_ingredient {
                    can_make = False;
                    break;
                }
            }
            
            if can_make {
                print(f"✓ {recipe.name} ({recipe.cuisine}, difficulty: {recipe.difficulty})");
            } else {
                print(f"✗ {recipe.name} - Missing ingredients");
            }
        }
    }
}

with entry {
    chicken = root ++> Ingredient(name="chicken", category="protein");
    rice = root ++> Ingredient(name="rice", category="grain");
    onion = root ++> Ingredient(name="onion", category="vegetable");
    garlic = root ++> Ingredient(name="garlic", category="vegetable");
    pasta = root ++> Ingredient(name="pasta", category="grain");
    tomato = root ++> Ingredient(name="tomato", category="vegetable");
    cheese = root ++> Ingredient(name="cheese", category="dairy");
    
    fried_rice = root ++> Recipe(name="Chicken Fried Rice", cuisine="Asian", difficulty=2, prep_time=25);
    pasta_dish = root ++> Recipe(name="Simple Pasta", cuisine="Italian", difficulty=1, prep_time=20);
    
    fried_rice +>:Uses(amount="200g", required=True):+> chicken;
    fried_rice +>:Uses(amount="2 cups", required=True):+> rice;
    fried_rice +>:Uses(amount="1 medium", required=True):+> onion;
    fried_rice +>:Uses(amount="2 cloves", required=False):+> garlic;
    
    pasta_dish +>:Uses(amount="300g", required=True):+> pasta;
    pasta_dish +>:Uses(amount="2 medium", required=True):+> tomato;
    pasta_dish +>:Uses(amount="50g", required=False):+> cheese;
    
    thiru = root ++> Person(name="Thiru", skill_level=2);
    tonystark = root ++> Person(name="TonyStark", skill_level=3);
    
    thiru +>:HasIngredient:+> chicken;
    thiru +>:HasIngredient:+> rice;
    thiru +>:HasIngredient:+> onion;
    thiru +>:HasIngredient:+> garlic;
    
    tonystark +>:HasIngredient:+> pasta;
    tonystark +>:HasIngredient:+> tomato;
    tonystark +>:HasIngredient:+> cheese;
    
    print("=== Thiru's Recipe Search ===");
    thiru spawn RecipeFinder();
    
    print("\n=== TonyStark's Recipe Search ===");
    tonystark spawn RecipeFinder();
}