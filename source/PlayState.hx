package;

import nape.phys.Material;
import flixel.addons.nape.FlxNapeSpace;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import nape.constraint.DistanceJoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;


class PlayState extends FlxState {
    public static var cardJoint:DistanceJoint;
    public var deck:Deck;
    public static var hands:Array<Hand>;

    override public function create():Void {
        super.create();
        //Creating the NapeSpace to enable collide around the window
        FlxNapeSpace.init();
        FlxNapeSpace.createWalls();

        deck = new Deck();
        for (c in deck.cards) {
            add(c);
        }

        hands = new Array<Hand>();
        for(e in Type.allEnums(CardinalDirection)) {
            hands.push(new Hand(e));
        }

    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (cardJoint != null) {
            cardJoint.anchor1 = Vec2.weak(FlxG.mouse.x, FlxG.mouse.y);
        }

        // Remove the joint again if the mouse is not down
        if (FlxG.mouse.justReleased) {
            if (cardJoint == null) {
                return;
            }

            cardJoint.space = null;
            cardJoint = null;
        }

        // Keyboard hotkey to reset the state
        if (FlxG.keys.pressed.R) {
            FlxG.resetState();
        }

        if (FlxG.keys.justReleased.A) {
            deck.distribute();
        }
    }
}
