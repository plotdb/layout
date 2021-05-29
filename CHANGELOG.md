# v0.0.6

 - fix bug: init cb with promise should use long wavy arrow 


# v0.0.5

 - add css rules for `data-debug` for checking layout result
 - add `data-only` tag for indicating layout elements with manually generated render element counterparts.
 - add option in `update` function call to force not rendering.


# v0.0.4

 - tweak init process:
   - layout init ( including prepare dom ) 
   - caller init ( may alter dom )
   - layout update ( lookup dom nodes again )
     - wait init resolves if init return a promise.


# v0.0.3

 - better scoping CSS class with `pdl` prefix. 
 - unify class name and attribute between render and layout elements.
 - add feature: auto generate SVG tree.


# v0.0.2

 - use better namespaced class name.
 - tweak demo code file structure


# v0.0.1

init commit
