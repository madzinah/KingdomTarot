package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIButton;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState {
    override public function create():Void {
        super.create();
        var play = new FlxUIButton(0, 0, "Play", clickPlay);

        // Centering play button
        play.x = FlxG.width / 2 - play.width / 2;
        play.y = FlxG.height / 2 - play.height / 2;

        add(play);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    public function clickPlay():Void {
        FlxG.switchState(new PlayState());
    }
}
