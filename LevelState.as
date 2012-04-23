package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class LevelState extends FlxState {
  
    protected var _snake:Snake;
    protected var _food:FlxGroup;
    protected var _pointHud:Tween;
    protected var _hud:FlxText;
    protected var _score:int;
    protected var _bonusTimer:Number = 0;
    protected var _bonusTimerPoints:Number = 0;
    protected var _bonusBar:FlxSprite;
    protected var _obstacles:FlxGroup;
    protected var _unspawnable:FlxGroup;
      
    override public function create():void {

      FlxG.log("Starting game");

      FlxG.mouse.hide();

      _score = 0;
      
      _snake = new Snake(8);
      _food = new FlxGroup();

      _hud = new FlxText(32,32,400,'0');
      _hud.size = 16;

      _bonusBar = new FlxSprite(450,32);
      _bonusBar.makeGraphic(1,8,0xffff0000);
      _bonusBar.origin.x = _bonusBar.origin.y = 0;
      _bonusBar.scale.x = 0;

      _obstacles = new FlxGroup();

      addBackgrounds();
      addObstacles();
  
      _unspawnable = new FlxGroup();
      _unspawnable.add(_food);
      _unspawnable.add(_snake);
      _unspawnable.add(_obstacles);

      spawnFoods(3);
      add(_food);
      add(_snake);
      add(_snake.tailCam);
      FlxG.addCamera(_snake.tailCam);
      
      add(_hud);
      add(_bonusBar);
      
    }

    /* Sort of abstract functions */
    protected function addBackgrounds():void {
    }

    protected function addObstacles():void {
    }

    protected function updateHud():void {
      _hud.text = "Hi, " + FlxKongregate.getUserName +"! Score: " + String(_score) + "\nLives: " + String(_snake.lives);
      _hud.y = ((64 - _hud.height) / 2) + 16;
    }

    protected function spawnFoods(count:int):void {
      for(var i:int = 0; i < count; i++) {
        spawnFood();
      }
    }

    protected function levelOver():void {
      FlxG.score = _score;
      FlxG.switchState(new GameOver);
    }

    override public function update():void {
      super.update();

      _bonusTimer -= FlxG.elapsed;

      if(_snake.lives < 0) {
        levelOver();
      }

      if(_bonusTimer > 0) {
        _bonusBar.scale.x = (_bonusTimer / 2) * 25;
      } else {
        _bonusTimerPoints = 0;
        _bonusBar.scale.x = 0;
      }

      _bonusBar.x = _snake.head.x - 5;
      _bonusBar.y = _snake.head.y - 24;

      // I tried to use FlxG.overlap for this, but sometimes, the callback will
      // be called twice. This works, so leave it like this.
      for(var i:int = 0; i < _food.length; i++){
        if(_snake.head.overlaps(_food.members[i])){
          eat(_snake.head, _food.members[i]);
        }
      }
      if(_snake.alive && !_snake.head.onScreen()) {
        _snake.die();
      }
      if(_snake.alive && _snake.head.overlaps(_obstacles)) {
        _snake.die();
      }

      updateHud();
    }

    protected function initPointHUD(egg:Egg, points:String, Color:uint = 0xffffffff, Delay:Number = 0.5, Speed:int = 1):void { 
      _pointHud = new Tween(Delay, 20, egg.x, egg.y, 40, Color, points, Speed); 
      add(_pointHud);  
    } 

    protected function eat(snakeHead:FlxSprite, egg:Egg):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      spawnFood();

      // TODO: This allocates too many objects. Think about how to reduce this.
      var shells:FlxEmitter = egg.shells;
      var points:int = 0;
      shells.at(snakeHead);
      shells.start(true, 3);
      add(shells);

      _food.remove(egg, true);
      
      _snake.faster();
      _snake.swallow(egg);
      points += egg.points;

      if(_bonusTimer > 0) {
        _bonusTimerPoints += 2;
        initPointHUD(egg, '+' + String(_bonusTimerPoints), 0xffedf249, 1.5, 2); 
        _score += _bonusTimerPoints;
      }

      _score += points;
      initPointHUD(egg, egg.points.toString());
      _bonusTimer = 2;
    
      var combo:Array = _snake.doCombos(egg);
      for(var i:int = 0; i < combo.length; i++) {
        initPointHUD(combo[i], '+5', 0xffff0000, 1.5, 2); 
        _score += 5;
      }
    }

    protected function hitBoundary(snakeHead:FlxObject, tile:FlxObject):void {
      FlxG.log("Hitting at " + tile.x + ", " + tile.y);
      _snake.die(); 
    }

    protected function spawnFood():void {
      reallySpawnFood(3);
    }
    
    protected function reallySpawnFood(n:int):void {
      var egg:Egg = new Egg(Math.floor(Math.random() * n));

      var wTiles:int = FlxG.width / 15;
      var hTiles:int = FlxG.height / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        egg.x = int(1 + (Math.random() * wTiles)) * 15;
        egg.y = int(6 + (Math.random() * hTiles)) * 15;
      } while(egg.overlaps(_unspawnable));
      _food.add(egg);

    }
    
    override public function destroy():void {
      remove(_snake.tailCam);
      super.destroy();
    }
  }
}
