# Card Framework

**Card Framework** is a lightweight, extensible toolkit for **creating 2D card games** in the **Godot Engine**. Whether you're building a **classic Solitaire**, a **TCG (Trading Card Game)**, or a **deck-building roguelike**. the Card Framework provides flexible card handling and UI structures to speed up development. Use this framework as a **starting point** for card-based gameplay in any 2D project. The following sections will guide you through setup, usage, and customization.

## Features
* **Card Creation & Management**: Easily define and instantiate cards with custom attributes or visuals.
* **Drag-and-Drop Interactions**: Built-in 2D control nodes to handle common card movements.
* **Card Container**: Create and manage various modules like Piles or Hands, enabling flexible card organization in different game scenarios.
* **Scalable Architecture**: Extend or modify the base classes to suit various genres (Solitaire, TCG, etc.).
* **Lightweight & Modular**: Include only the parts you need, so it won't bloat your project.


## Installation
1. **Download from Godot Editor’s AssetLib**
   * Open Godot and navigate to the **AssetLib** tab.
   * Search for **CardFramework** and download the latest version.
2. **Manual Download to** `addons/card-framework`
   * Alternatively, download the latest version directly.
   * Copy or move the contents to your project under `res://addons/card-framework`.
3. **Check Usage Examples**
   * The folders `example1` and `freecell` demonstrate usage in real scenarios.
   * If you don’t need them, you can remove those folders from your project.


## Getting Started

1. **Instantiate the Card Manager**
   * In any scene that needs card functionality, **instantiate** the scene at `card-framework/card_manager.tscn`.
2. **Organize Card Images**
   * Save the images for your card fronts (and other card-related art) inside the designated `card_asset_dir` folder.
3. **Prepare Card Metadata**
   * Create JSON files that describe each card’s metadata (e.g., name, rank, suit, custom properties), and place them into the `card_info_dir` folder.
4. **Set Up the CardManager**
   * In the **Inspector** for your `CardManager` node, configure:
     * `card_size`: The default width/height for each card.
     * `card_asset_dir`: The folder containing your card images.
     * `card_info_dir`: The folder containing your JSON metadata.
     * `back_image`: The texture to use for the card’s backside.
5. **Assign a CardFactory**
   * Under the `CardManager`, choose the `CardFactory` class to use.
   * You can use the default `CardFactory` or **create a custom factory** (by extending `CardFactory`) and set it here.
6. **Add Card Containers**
   * Within `CardManager`, instantiate and arrange `Pile`, `Hand`, or any custom `CardContainer` nodes you’ve created.
   * Use these containers to organize the deck, discard piles, player hands, or any other card layout required by your game.

## Project Structure

- `res://freecell/`
  - Game logic, scenes, and scripts related to FreeCell gameplay.
- `res://freecell/assets/images/cards/`
  - Card images from the **Boardgame Pack** on Kenney.nl.
- `res://freecell/assets/images/spots/`
  - Spot images generated using ChatGPT.
- Other folders as needed...

## How to Run

1. Open this folder (`res://`) in the Godot Editor.
2. Press the **Play** button (or F5) to start the game.

---

## License / Credits

---

### Kenney.nl Card Assets

- **Path**: `res://freecell/assets/images/cards/`
- **Source**: [Kenney - Boardgame Pack](https://www.kenney.nl/assets/boardgame-pack)
- **License**: [CC0 (Creative Commons Zero)](https://creativecommons.org/publicdomain/zero/1.0/)

**What does CC0 mean?**  
You can freely use, modify, and distribute these assets for personal or commercial projects without attribution or restrictions. However, a mention of the original source (Kenney.nl) is always appreciated.

---

### ChatGPT-Generated Spot Images

- **Path**: `res://freecell/assets/images/spots/`
- **Description**: These spot images were generated with assistance from ChatGPT.
- **Usage**: They can be used freely within this project.  
  (If you plan to redistribute them separately, please ensure compliance with any relevant policies or terms.)

---

## Additional Notes

- Keep this `README.md` updated if you add or replace any assets (e.g., fonts, sounds, images).
- Make sure to follow each asset’s license terms if you distribute or publish this project.
- If you have further questions, check the respective asset creator’s website or licensing details.

Happy FreeCell gaming!
