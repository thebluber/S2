package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  import flash.utils.*;
  import org.humoralpathologie.axgl.MenuButton;
  import flash.events.MouseEvent;  
  
  public class LevelSelect extends AxState {

    [Embed(source='assets/images/Levelauswahl/background.png')] protected static var Background:Class;
    [Embed(source='assets/images/Levelauswahl/header_15-20.png')] protected static var Header:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level1_15-262.png')] protected static var L1:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level2_261-377.png')] protected static var L2:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level3_514-509.png')] protected static var L3:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level4_261-626.png')] protected static var L4:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level5_11-743.png')] protected static var L5:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level6_261-890.png')] protected static var L6:Class;
    [Embed(source='assets/images/Levelauswahl/tile-level7_515-1009.png')] protected static var L7:Class;
    [Embed(source='assets/images/Levelauswahl/tile-boss_54-1190.png')] protected static var L8:Class;
    [Embed(source='assets/images/levelNo.png')] protected static var LNo:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;


    
    private static var _levels:Array = [{pic: L1, x: 15, y: 262, state: Level1}, 
                                        {pic: L2, x: 261, y: 377, state: Level2},
                                        {pic: L3, x: 514, y: 509, state: Level3},
                                        {pic: L4, x: 261, y: 626, state: null},
                                        {pic: L5, x: 11, y: 743, state: null},
                                        {pic: L6, x: 261, y: 890, state: null},
                                        {pic: L7, x: 515, y: 1009, state: null},
                                        {pic: L8, x: 54, y: 1190, state: null}];

    private var _header:AxSprite;    
    private var _background:AxSprite;
    private var _level1:AxSprite;
    private var _level2:AxSprite;
    private var _level3:AxSprite;
    private var _level4:AxSprite;
    private var _level5:AxSprite;
    private var _level6:AxSprite;
    private var _level7:AxSprite;
    private var _level8:AxSprite;
    private var _draggable:AxGroup;  
    private var _posY:Number;
    private var _deltaY:Number;
    private var _pressed:Boolean = false;
  
    override public function create():void {
      super.create();
      _background = new AxSprite(0, 0, Background);
      _header = new AxSprite(15, 20, Header);
      _draggable = new AxGroup();
      _draggable.add(_background);
      _draggable.add(_header);
 
      add(_background);
      add(_header);
      makeButtons();
    }

    private function makeButtons():void{
      var btn:MenuButton;
      for (var i:int = 0; i < _levels.length; i++) {
        btn = new MenuButton(_levels[i].x, _levels[i].y, 1, _levels[i].pic, switchToState(_levels[i].state));
        add(btn);
        _draggable.add(btn);
        if (SaveGame.levelUnlocked(i + 1)) {
          btn.currentLevel = 1;
        } 
      }
    }

    private function mousePress():void {
      if(!_pressed){
        _posY = Ax.mouse.y;
        _pressed = true;
      }
       _deltaY = Ax.mouse.y - _posY;
       if (_background.y + _deltaY < 0 && _background.y + _deltaY > -1400) {
        for (var i:int = 0; i < _draggable.members.length; i++) {
           _draggable.members[i].y += _deltaY;
        }
       }
    }
    private function mouseRelease():void {
      _posY = 0;
      _pressed = false;
    }

    private function dragger():void {
      if (_background.held()){
        mousePress();
      } else if (_background.released()){
        mouseRelease();
      }
    }

    private function switchToState(state:Class):Function {
      return function ():void {
        if (state) {  
          Ax.switchState(new state);
        }
      }
    }
    
    override public function update():void {
      super.update();
      dragger();
    }
  }
} 
