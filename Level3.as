package {
  import org.axgl.*;
  import org.axgl.text.*;

  public class Level3 extends LevelState {
    // Assets
    [Embed(source='assets/images/Level03/level03.png')] protected var Background:Class;
    [Embed(source='assets/images/Level03/level03_stein.png')] protected var Stone:Class;
    [Embed(source='assets/images/Level03/SteinAugenGlühen.png')] protected var Eye:Class;
    [Embed(source='assets/images/Level03/OverlayLV3Außen.png')] protected var OverlayOut:Class;
    [Embed(source='assets/images/Level03/OverlayLV3Innen.png')] protected var OverlayIn:Class;
    // Variablen
    protected var _background:AxSprite = null;
    private var _stone:AxSprite;
    private var _evilEye:AxSprite;

    override public function create():void {
      _overlayIn = new AxSprite(-50, -50, OverlayIn);
      _overlayOut = new AxSprite(-50, -50, OverlayOut);
      super.create();
      _spawnRotten = true;
      _comboSet.addCombo(new FasterCombo);
      _snake.lives = 3;
      _levelNumber = 3;
      _switchLevel = new SwitchLevel(Level3, Level3);
    }
    override protected function addBackgrounds():void {
      _background = new AxSprite(0,0);
      _background.load(Background, 640, 480);
      _background.addAnimation('morph',[0,1],8);
      _background.animate('morph');
      add(_background);
      _stone = new AxSprite(0, 0, Stone);
      add(_stone);
    }

    override protected function addObstacles():void {
      var stone:AxSprite = new AxSprite(180,225);      
      stone.create(75,45,0x00ff0000);
      _obstacles.add(stone);
      stone = new AxSprite(195,240);
      stone.create(75,45,0x000000ff);
      _obstacles.add(stone);
      add(_obstacles);
    }

    override protected function spawnFood():void {
      var newEgg:Egg;
      var n:Number = Math.random();
      if(n < 0.4) {
        newEgg = new Egg(0);
      } else {
        newEgg = new Egg(1);
      }
      
      spawnEgg(newEgg);
    }

    override protected function addHud():void {
      _hud = new Hud(["lives", "speed", "time", "score", "combo", "poison"]); 
      add(_hud);
    }

    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = _timerHud;
      _hud.speedText = (_snakeSpeed < 10) ? "0" + String(_snakeSpeed) : String(_snakeSpeed);
      _hud.scoreText = String(_score); 
      _hud.comboText = String(_combos) + "/10"; 
      _hud.poisonText = String(_poisonEgg);
    }

    override protected function checkWinConditions():Boolean {
      return(_combos >= 10 || _eggAmount >= 100 || _timerMin >= 4)
    }

    override protected function submitPoints():void {
      _switchLevel.setTimer(int(_timerMin * 60 + _timerSec), 180);
      super.submitPoints();
    }

  }
}
