package {
  import org.axgl.*;
  import org.axgl.text.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;
  
  public class Level1 extends LevelState {
    // Assets
    [Embed(source='assets/images/level01bg.png')] protected var Background:Class;
    [Embed(source='assets/images/BaumschattenAußenLV1.png')] protected var ShadowOut:Class;
    [Embed(source='assets/images/BaumschattenInnenLV1.png')] protected var ShadowIn:Class;
    // Variablen
    private var _background:AxSprite = null;
    override public function create():void {
      _overlayIn = new AxSprite(Ax.width/2 - 600, Ax.height/2 - 450, ShadowIn);
      _overlayOut = new AxSprite(Ax.width/2 - 600, Ax.height/2 - 450, ShadowOut);
      super.create();
      
      _comboSet.addCombo(new FasterCombo);

      _levelNumber = 1;

      _snake.lives = 1;
      _switchLevel = new SwitchLevel(Level1, Level2);
      
    }

    override public function update():void {
      super.update();
      if (_eggAmount == 40 && _snake.lives != 2) {
        _snake.lives++;
        //_bup.play();
      }
    }
    
    override protected function addBackgrounds():void {
      _background = new AxSprite(0, 0, Background);
      add(_background);
    }
    
    override protected function addObstacles():void {
      var stone1:AxSprite = new AxSprite(135,0);      
      stone1.create(90,45,0x00ff00ff);
      var stone2:AxSprite = new AxSprite(150,15);      
      stone2.create(45,45,0x000000ff);
      _obstacles.add(stone1);
      _obstacles.add(stone2);
      add(_obstacles);
    }
    
    override protected function addHud():void {
      _hud = new Hud(["lives", "time", "score", "egg"]); 
      add(_hud);
    }
    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = _timerHud;
      _hud.eggText = String(_eggAmount) + "/50";
      _hud.scoreText = String(_score); 
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 11);
      var egg:Egg;

      if (rand > 6) {
        egg = new Egg(1);  
      } else {
        egg = new Egg(0); 
      } 
 
      egg.points = 2;
      spawnEgg(egg);
      
    }
    override protected function submitPoints():void {
      _switchLevel.setTimer(int(_timerMin * 60 + _timerSec), 180);
      super.submitPoints();
    }
    override protected function checkWinConditions():Boolean {
      return (_eggAmount >= 50);
    }


  }
}
