package testing;

import haxe.ds.Vector;
import haxe.ad.duals.DualMath;
import haxe.ad.duals.DualNumber;

class Duals {
  static function main() {
    testMacros();
  }

  private static function testMacros() {
    var test = new DualNumber(2.0, 1.0);
    //trace(SomeFunctions.test1(new DualNumber(3.0, 1.0)));
    //trace(SomeFunctions.test1_dual(new DualNumber(3.0, 1.0)));

    var out = new Vector<DualNumber>(2);
    SomeFunctions.test2(test, out);

    trace(4.0 - test);
    trace(test - 4.0);
    trace(test/4.0);
    trace(4.0/test);
  }

  private static function testDuals() {
    var v = Math.PI/4;
    var dual1 = new DualNumber(v, 1.0);
    
    quickAssertEquals((dual1 - dual1).d, 0.0);
    quickAssertEquals((dual1 + dual1).d, 2.0);
    quickAssertEquals((dual1*dual1).d, 2*v);
    quickAssertEquals((dual1/dual1).d, 0.0);

    quickAssertEquals(DualMath.pow(dual1, 2).d, 2*v);
    quickAssertEquals(DualMath.sin(dual1).d, Math.cos(v));
    quickAssertEquals(DualMath.cos(dual1).d, -Math.sin(v));
    quickAssertEquals(DualMath.tan(dual1).d, 1 + (Math.tan(v)*Math.tan(v)));
    quickAssertEquals(DualMath.exp(dual1).d, Math.exp(v));
    quickAssertEquals(DualMath.log(dual1).d, 1/v);
    quickAssertEquals(DualMath.abs(dual1).d, v/Math.abs(v));

    quickAssertEquals((DualMath.cos(dual1) * DualMath.sin(dual1)).d, Math.cos(2*v));
  }

  private static var index : Int = 0;
  private static function quickAssertEquals(left : Float, right : Float) : Void {
    var string = Std.string(left) + " == " + Std.string(right);

    if(left != right)
      trace(index + '.\t Assert failed: ' + string);
    else
      trace(index + '.\t Assert passed: ' + string);

    index++;
  }
}

@:build(haxe.ad.duals.macros.Converter.build())
private class SomeFunctions {
  @:makeDual public static function test1(x : Float) : Float {
    var t  = 3*x;
    return Math.cos(t);
  }

  public static function test1_dual(x : DualNumber) : DualNumber {
    return DualMath.cos(x*x);
  }

  @:makeDual public static function test2(x : Float, out : Vector<Float>) : Void {
    out[0] = 3*x*x;
    out[1] = 2*x + 2;
  }
}