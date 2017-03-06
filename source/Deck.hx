package ;


import js.html.CanvasRenderingContext2D;
import flixel.FlxG;
import openfl.Assets;
class Deck {

    public var cards:Array<Card>; // Array of all cards in the Deck
    var pickedCards:Array<Int>; // Exclusive Array to avoid picking two similar cards.
    var cardsPaths:Array<String> = Assets.list(AssetType.IMAGE); // Macro to get every path in the asset/images folder

    public function new() {
        cards = new Array<Card>();
        pickedCards = new Array<Int>();

        cardsPaths = cardsPaths.filter(filterCards);
        for (i in 0...78) {
            var index = FlxG.random.int(0, 77, pickedCards);
            pickedCards.push(index); // Adding the number of index to the Array to exclude it from a next random.int()
            cards.push(new Card(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2),cardsPaths[index]));
        }
    }

    public function filterCards(s:String):Bool {
        return s.indexOf("cards") != -1;
    }

    public function distribute():Void {
        if (cards.length != 78)
            return;
        var hands = PlayState.hands;
        var handsNb = hands.length;
        var i = 0;
        // Standard distribution
       /* var ar = new Array<Array<Card>>();
        for (h in hands) {
            ar.push(new Array<Card>());
        }
        for (c in cards) {
            ar[i % handsNb].push(c);
            i++;
        }
        i = 0;
        for (h in hands) {
            h.addCards(ar[i]);
            i++;
        }*/
        // Tarot Distribution with Dog
        var chance:Int = 22; // You have 28 chances to put cards in the dogs, removing 6 for the cards
                             // plus one for the exclusion.
        var currentHand = 0;
        var hold:Array<Card> = new Array<Card>();
        var dog:Array<Card> = new Array<Card>();
        for (c in cards) {
            if (i == 0 && dog.length < 6 && Std.random(chance) == 0){
                dog.push(c);
                trace(cards.indexOf(c));
                chance--;
            } else {
                hold.push(c);
                i++;
            }
            if (i == 3) {
                hands[currentHand].addCards(hold);
                hold = new Array<Card>();
                currentHand++;
                currentHand %= 4;
                i = 0;
                chance--;
            }
        }
        cards = dog;
    }


}
