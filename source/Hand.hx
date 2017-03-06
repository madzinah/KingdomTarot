package ;

import flixel.tweens.FlxTween;
import flixel.FlxG;
class Hand {

    public var cards:Array<Card>;
    private var direction:CardinalDirection;
    private static var SPAN:Int = 0;

    public function new(cD:CardinalDirection) {
        direction = cD;
        cards = new Array<Card>();
    }


    public function addCard(c:Card) {
        if (c == null)
            return;
        cards.push(c);

        // location changing
        cardsDefaultPositionning();
    }

    public function addCards(c:Array<Card>) {
        if (c == null)
            return;
        cards = cards.concat(c);
        // location changing
        cardsDefaultPositionning();
    }

    private function cardsDefaultPositionning() {
        var number = cards.length;

        if (number <= 0) {
            return;
        }
        cards.sort(sortCard);
        var x, y, a, xE, yE, xS, yS:Int;
        var reveal:Bool = false;
        switch (direction) {
            case North:
                x = Std.int((FlxG.width - cards[0].width) / 2);
                y = 0;
                a = 180;
                xE = - SPAN / 2;
                yE = 0;
                xS = 1;
                yS = 0;
            case South:
                x = Std.int((FlxG.width - cards[0].width) / 2);
                y = Std.int(FlxG.height - cards[0].height / 2);
                a = 0;
                xE = SPAN / 2;
                yE = 0;
                xS = -1;
                yS = 0;
                reveal = true;
            case East:
                x = Std.int(FlxG.width - cards[0].height / 2);
                y = Std.int((FlxG.height - cards[0].width) / 2);
                a = - 90;
                xE = 0;
                yE = Std.int(SPAN / 2);
                xS = 0;
                yS = -1;
            case West:
                x = Std.int(cards[0].height / 2);
                y = Std.int((FlxG.height - cards[0].width) / 2);
                a = 90;
                xE = 0;
                yE = Std.int(- SPAN / 2);
                xS = 0;
                yS = 1;
        }
        var firstCard, firstX, firstY:Int;
        var ref:Card;

        if (number % 2 == 0) {
            firstX = Std.int(x + xE);
            firstY = Std.int(y + yE);
        } else {
            firstX = x;
            firstY = y;
        }
        if (number == 1) {
            firstCard = 0;
        } else {
            firstCard = Std.int(number / 2);
        }

        ref = cards[firstCard];
        ref.move(firstX, firstY, a, reveal);

        for (i in 0...firstCard) {
            cards[i].move(Std.int(firstX + xS * (firstCard - i) * (SPAN + cards[0].width)),
            Std.int(firstY + yS * (firstCard - i) * (SPAN + cards[0].width)), a, reveal);
        }
        for (i in (firstCard + 1)...number) {
            cards[i].move(Std.int(firstX - xS * (i - firstCard) * (SPAN + cards[0].width)),
            Std.int(firstY - yS * (i - firstCard) * (SPAN + cards[0].width)), a, reveal);
        }


    }

    public function turnCards():Void {
        for(c in cards) {
            c.turn(null);
        }
    }

    public function sortCard(a:Card, b:Card):Int {
        if ( a.cardValue > b.cardValue) {
            return 1;
        }
        if ( a.cardValue == b.cardValue) {
            return 0;
        }
        return -1;
    }
}
