package coconut.vdom;

import tink.state.Observable;

class ViewBase<Original, Presented> extends Renderable {
  @:noCompletion var __lastPresented:Presented;
  
  public function new(data:Original, extract:Original->Presented, renderer:Presented->vdom.VNode, key:vdom.Attr.Key) {
    super(Observable.auto(function () {
      __beforeExtract();
      var nu = extract(data);
      return 
        if (__lastPresented != null && __compare(nu, __lastPresented)) last;
        else renderer(__lastPresented = nu);
    }), key);
  }

  @:noCompletion private function __beforeExtract() {}
  @:noCompletion private function __resetCache<A>(?v:A) 
    this.__lastPresented = null;

  @:noCompletion private function __copyCache(old:ViewBase<Original, Presented>) 
    this.__lastPresented = old.__lastPresented;

  @:noCompletion private function __compare(nu:Presented, old:Presented) {
    if (nu == old) return true;

    for (f in Reflect.fields(nu)) {
      var nu = Reflect.field(nu, f),
          old = Reflect.field(old, f);

      if (old != nu) 
        switch [Std.instance(old, ConstObservable), Std.instance(nu, ConstObservable)] {
          case [null, _] | [_, null]: 
            return false;
          case [a, b]: 
            if (a.m.value != b.m.value)
              return false;
        }
    }
    return true;
  }
    
}