package ;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import nape.phys.Body;
import nape.dynamics.InteractionFilter;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxG;
import flixel.FlxSprite;
import nape.geom.Vec2;
import nape.constraint.DistanceJoint;
import flixel.addons.nape.FlxNapeSprite;

class Card extends FlxNapeSprite {

    private var turned:Bool = false;
    public var cardValue:String;
    private var changingAngle:Bool = false;
    private var newAngle:Int;
    public var tween:FlxTween;
    private var text:FlxText;

    public function new(X:Int, Y:Int, SimpleGraphic:String) {
        super(X, Y, "assets/images/backs/back5.png", false); // load the back card first before it's turned
        cardValue = SimpleGraphic; // Saving the path to the card recto
        createRectangularBody();
        antialiasing = true;
        setDrag(0.95, 0.95);
        body.setShapeFilters(new InteractionFilter(2, ~2)); // To avoid any cards interaction with each others
        FlxMouseEventManager.add(this, onDown, null, onOver, onOut);
    }

    private function onDown(Sprite:FlxSprite) {

        turn(null);

        // Setting a cardJoint to force the movement of the card
        PlayState.cardJoint = new DistanceJoint(FlxNapeSpace.space.world, body, Vec2.weak(FlxG.mouse.x, FlxG.mouse.y),
        body.worldPointToLocal(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)), 0, 0);
        PlayState.cardJoint.stiff = false;
        PlayState.cardJoint.damping = 1;
        PlayState.cardJoint.frequency = 2;
        PlayState.cardJoint.space = FlxNapeSpace.space;
    }

    private function onOver(Sprite:FlxSprite) {
        if (turned) {

        }
    }

    private function onOut(Sprite:FlxSprite) {

    }

    private function revealCard(Tween:FlxTween):Void {
        loadGraphic(cardValue, false);
        tween = FlxTween.tween(scale, { x: 1 }, 0.1);
    }

    public function move(X:Int, Y:Int, newAngle:Int, reveal:Bool):Void {
        var options:TweenOptions = {ease: FlxEase.sineIn};
        var options2:TweenOptions = {ease: FlxEase.sineIn, onComplete: turn};
        var duration = 0.7;
        if (reveal) {
            tween = FlxTween.linearMotion(this, x + width / 2, y + height / 2, X, Y, duration, true, options2);
        } else {
            tween = FlxTween.linearMotion(this, x + width / 2, y + height / 2, X, Y, duration, true, options);
        }

        changingAngle = true;
        this.newAngle = newAngle;
    }

    public function turn(Tween:FlxTween) {
        if (!turned) {
            turned = true;
            tween = FlxTween.tween(scale, { x: 0 }, 0.1, { onComplete: revealCard }); // Animation Manager
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (changingAngle) {
            var dif = angle - newAngle;
            body.angularVel = Math.abs(dif) > 100 ? - dif / Math.abs(dif) * 100 / 8 : - dif / 8; // TODO
            if ( Math.abs(dif) < 0.5) {
                body.angularVel = 0;
                changingAngle = false;
                newAngle = 0;
            }
        }

    }
}
