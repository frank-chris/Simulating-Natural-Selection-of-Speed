;; Simulating the Natural Selection of Speed in a Population of Animals
;; Author: Chris Francis, 18110041

;; breeds
breed [foods food]
breed [animals animal]

;; animals-own variables
animals-own [energy speed collected-food cost]

to setup
  ;; command to setup the simulation

  ;; clear everything
  clear-all
  ;; create a white background
  ask patches [ set pcolor white ]
  ;; create animals
  make-animals
  ;; create food
  make-foods
  reset-ticks
end

to make-animals
  ;; command to create animals

  create-animals animal-count [
    ;; set coordinates randomly
    setxy random-xcor random-ycor
    set color green
    ;; max-energy is a global variable that denotes
    ;; the maximum energy an animal can have. The energy
    ;; of each surviving/created animal is set to max-energy
    ;; at the start of each generation.
    set energy max-energy
    ;; initial-speed is the value of speed that all the
    ;; animals have at the start of the simulation.
    set speed initial-speed
    set collected-food 0
    ;; cost = speed^2
    set cost speed * speed
  ]
end

to make-foods
  ;; command to create food

  create-foods food-count[
    ;; set coordinates randomly
    setxy random-xcor random-ycor
    set color cyan
    set shape "dot"
  ]
end

to go
  ;; go command for simulation

  ;; command to make animals move and eat food if found
  move
  tick
  ;; end the generation after every 240 ticks
  if ((remainder ticks 240) = 0)[
    end-generation
  ]
end

to move
  ;; command to make animals move and eat food if found

  ask animals[
    ;; animals can move only if they have energy > 0
    if energy > 0 [
      ;; move a distance equal to speed
      fd speed
      ;; turn to a random direction
      facexy random-xcor random-ycor
      ;; reduce energy by cost
      set energy energy - cost
    ]
    ;; food items in radius 1
    let foods-found foods in-radius 1
    if (count foods-found > 0) [
      ;; eat the food items in radius 1 by increasing
      ;; collected-food of the animal and making the food items die
      set collected-food collected-food + count foods-found
      ask foods-found [ die ]
    ]
  ]
end

to end-generation
  ;; command to perform end of the generation tasks

  ask animals[
    (ifelse
      ;; animals with collected-food = 0 will die
      collected-food = 0[
        die
      ]
      ;; animals with collected-food = 1 will survive
      collected-food = 1[
        setxy random-xcor random-ycor
        set energy max-energy
        set collected-food 0
      ]
      [ ;; animals with collected-food > 1 will survive and reproduce
        setxy random-xcor random-ycor
        reproduce
        set energy max-energy
        set collected-food 0
      ]
    )
  ]
  ;; removing the remaining food
  ask foods[die]
  ;; creating new food for next generation
  make-foods
end

to reproduce
  ;; command to make animals reproduce with a probability of mutations

  ;; speed of the animal that called the command
  let parent-speed speed
  ;; create collected-food - 1 new animals
  hatch (collected-food - 1)[
    setxy random-xcor random-ycor
    set energy max-energy
    ;; if mutations are on, a mutation takes place with 50% probability
    ifelse mutations? and random 100 > 50 [
      ;; the speed of the new animal increases or decreases by a random value less than 0.1
      set speed parent-speed - 0.1 + random-float 0.2
    ]
    [
      ;; else no mutation
      set speed parent-speed
    ]
    (ifelse
      ;; if speed is more than the initial-speed of the simulation, make the turtle red
      speed > initial-speed
        [set color red]
      ;; if speed is less than the initial-speed of the simulation, make the turtle yellow
      speed < initial-speed
        [set color yellow]
      ;; if speed is equal to the initial-speed of the simulation, make the turtle green
        [set color green]
    )
    set cost speed * speed
    set collected-food 0
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
287
10
764
488
-1
-1
14.212121212121213
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
11
238
84
271
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
9
65
181
98
food-count
food-count
0
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
8
27
180
60
animal-count
animal-count
0
100
80.0
1
1
NIL
HORIZONTAL

BUTTON
93
239
156
272
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
778
257
1054
302
population size of animals
count animals
2
1
11

PLOT
777
306
1053
470
population size vs time
time
population
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count animals"

MONITOR
776
28
1052
73
Average speed of animals
sum [speed] of animals / count animals
4
1
11

PLOT
12
287
272
481
Speed Distribution of Animals
speed
no. of animals
0.0
5.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.1 1 -16777216 true "" "histogram [speed] of animals"

SLIDER
10
102
182
135
initial-speed
initial-speed
0
5
1.0
0.1
1
NIL
HORIZONTAL

PLOT
778
77
1050
233
avg speed of animals vs time
time
avg speed
0.0
10.0
0.0
5.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [speed] of animals / count animals"

SLIDER
10
146
182
179
max-energy
max-energy
50
300
120.0
2
1
NIL
HORIZONTAL

SWITCH
11
187
147
220
mutations?
mutations?
0
1
-1000

BUTTON
165
240
235
273
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

@#$#@#$#@
# Simulating the Natural Selection of Speed in a Population of Animals

Chris Francis, 18110041

This model was created as a part of the ES 491: Modeling and Simulation of Complex Systems course offered by Prof. Antonio Fonseca in semester 2 of the academic year 2020-21 at IIT Gandhinagar.

## 1. Purpose and patterns
The purpose of this model is to study the evolution of the trait ‘speed’ through natural selection in a population of animals living in a simple environment with finite food resources.  Studying the emergence of a value for the average speed of the population and investigating factors that could influence it are also important goals of this model. The model investigates if there are patterns in the way the emergent value of speed changes with various factors like food count, initial speed, maximum energy etc.

## 2. Entities, State Variables, and Scales
There are two types of agents in this model - animals and food. Both of them are turtle breeds. Food cannot move in the environment and spawns at random locations at the start of each generation. The number of food that spawns at the start of a generation is given by the global variable `food-count`. Animals can move around in the environment and eat food. They spawn at random locations at the start of a generation. However, the number of animals that spawn at the start of a generation is not fixed. At the end of each generation, an animal can die, survive or survive and reproduce depending on the number of food it collected in that generation. The number of animals that spawn in the first generation is given by the global variable `animal-count`. Food have the following variables: `xcor`, `ycor`, `size`, `shape`, `color`. Animals have the following variables: `xcor`, `ycor`,`size`, `shape`, `color`, `energy` (keeps track of the energy of an animal), `speed`(distance that the animal can move in a time step),  `cost`(amount of energy used in a time step for moving), `collected-food`(keeps track of the number of food collected by the animal in the current generation). 

The environment consists of all patches.  The patches make up a square grid world of 33 x 33 patches that wraps around both horizontally and vertically.

One generation is 240 time steps long.

## 3. Process Overview and Scheduling
There are multiple processes in the model as explained below. Every 240 time steps is called a generation. At the start of each generation, food and animals spawn at random locations. During a generation, animals move around in the environment. In each time step, an animal moves a distance equal to its `speed` variable and its `energy` decreases by an amount equal to its `cost` variable. If it finds a food within a radius of 1 unit, it eats the food. When a food is eaten by an animal, it dies and the `collected-food` variable of the animal increases by 1. At the end of a generation, an animal dies if its `collected-food` variable is 0 and survives if its `collected-food` variable is greater than 0. An animal that survives creates (`collected-food - 1`) new animals by reproducing. When an animal reproduces, the new animal has a 50% chance of having a mutation if `mutations?` are turned on(0% chance if `mutations?` are turned off). A mutation may cause its `speed` to increase or decrease by a number less than 0.1. The color of the new animal is set to red, yellow or green depending on whether its speed is greater, lower or equal to  `initial-speed`. The `cost` also increases or decreases according to the relation between `cost` and `speed`(`cost`=`speed`^2). The `energy` and `collected-food` of the surviving animal is reset to `max-energy` and 0 respectively. The remaining food is cleared and the next generation begins. 

## 4. Design Concepts
Basic principles: The basic topic of this model is how natural selection of the observable trait speed leads to the emergence of a value of speed for a populatioin of animals living in an environment with finite food resources.

Emergence: The model's primary emergent output is the value of average speed attained by the system over several generations.

Adaptive behavior: The adaptive behavior of animals is choice of speed: the decision of whether to increase or decrease speed based on cost-speed tradeoff. However, this decision is not taken by individual animals. Animals have no control over the speed mutations and the choice of a speed is made by the population as a whole depending on the environment and other factors.

Objective: There is no well-defined objective for the animals and no objectives at all for food. Animals have an indirect objective of surviving and reproducing as much as possible, which is why they eat any food item that is within radius 1 from them.

Prediction: The prediction is that natural selection will lead to a particular value of speed being selected preferentially over others regardless of the initial speed the animals started with. However this speed can depend on factors like food-count or max-energy.

Interaction: The animals interact with each other only indirectly via competition for food: an animal cannot eat a food that is already eaten by another animal. The movement of animals is random, so there is no hierarchy in this competition except for advantages caused by the speed value. 

Stochasticity: The initial state of the model is stochastic: the locations of animals and food are set randomly. Stochasticity is thus used to simulate an environment where the location of an animal does not cause a serious disadvantage or advantage. 

Whether a mutation takes place or not is also stochastic when mutations are turned on since you have a 50% chance of a mutation in that case. The degree of mutation is also stochastic since the change in speed can lie between parent-speed - 0.1 and parent-speed + 0.1. 

Observation: The View shows the location of each animal and food in the environment. The colors of the animals also show us whether its speed is higher, lower or equal to the initial speed of the animals when the simulation started. Graphs show the average speed of animals versus time, population size(count of animals) versus time and speed distribution of animals. The average speed of animals and the population size(count of animals) is also displayed using monitors.

## 5. Initialization
The environment(consisting of all patches) is initialized to be white when model starts. Animals and food are initialized by creating animal-count and food-count of them respectively. The locations of animals and food are chosen randomly and both are initialized with the default size. Animals are initialized with the default shape and green color while food are initialized with dot shape and cyan color. The energy, speed, cost and collected-food variables of animals are initialized as max-energy, initial-speed, speed^2 and 0 respectively. 

## 6. Input Data
The model has no input data.

## 7. Submodels

The make-animals and make-food submodels simply create animals and food as mentioned before. The move submodel handles the movement of animals and makes the animals eat any food within a radius of 1 unit from them. The end-generation submodel is used to perform the tasks required to be done at the end of a generation like handling the death, survival and reproduction of animals as well as clearing the remaining food and creating food for the next generation. The reproduce submodel handles the creation of new animals by an existing animal and also handles the mutations.

## CREDITS AND REFERENCES

Wilensky, U. (1999). NetLogo. [http://ccl.northwestern.edu/netlogo/](http://ccl.northwestern.edu/netlogo/). Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL. 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="initial_speed" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="250000"/>
    <metric>sum [speed] of animals / count animals</metric>
    <steppedValueSet variable="initial-speed" first="0.6" step="0.1" last="5"/>
    <enumeratedValueSet variable="max-energy">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animal-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutations?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="food_count" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="250000"/>
    <metric>sum [speed] of animals / count animals</metric>
    <enumeratedValueSet variable="initial-speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-energy">
      <value value="120"/>
    </enumeratedValueSet>
    <steppedValueSet variable="food-count" first="30" step="2" last="100"/>
    <enumeratedValueSet variable="animal-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutations?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="max_energy" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="250000"/>
    <metric>sum [speed] of animals / count animals</metric>
    <enumeratedValueSet variable="initial-speed">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="max-energy" first="50" step="5" last="300"/>
    <enumeratedValueSet variable="food-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animal-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutations?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="mutations_off" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>count animals</metric>
    <enumeratedValueSet variable="initial-speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-energy">
      <value value="120"/>
    </enumeratedValueSet>
    <steppedValueSet variable="food-count" first="30" step="2" last="100"/>
    <enumeratedValueSet variable="animal-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutations?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="mutations_on" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>count animals</metric>
    <enumeratedValueSet variable="initial-speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-energy">
      <value value="120"/>
    </enumeratedValueSet>
    <steppedValueSet variable="food-count" first="30" step="2" last="100"/>
    <enumeratedValueSet variable="animal-count">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutations?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
