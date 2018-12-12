(ns chronal-coordinates.core
  (:gen-class))


(def test-coords [[1 1] [1 6] [8 3] [3 4] [5 5] [8 9]])

(def real-coords [[77  279] [216 187] [72  301] [183 82 ] [57  170] [46  335]
                  [55  89 ] [71  114] [313 358] [82  88 ] [78  136] [339 314]
                  [156 281] [260 288] [125 249] [150 130] [210 271] [190 258]
                  [73  287] [187 332] [283 353] [66  158] [108 97 ] [237 278]
                  [243 160] [61  52 ] [353 107] [260 184] [234 321] [181 270]
                  [104 84 ] [290 109] [193 342] [43  294] [134 211] [50  129]
                  [92  112] [309 130] [291 170] [89  204] [186 177] [286 302]
                  [188 145] [40  52 ] [254 292] [270 287] [238 216] [299 184]
                  [141 264] [117 129]])

(defn inf?
  [x y minx maxx miny maxy]
  (or (= minx x) (= miny y) (= maxx x) (= maxy y)))

(defn only?
  [best col]
  (= (reduce (fn [n x] (if (= x best) (inc n) n)) 0 col) 1))

(defn dist
  [[x1 y1] [x2 y2]]
  (+ (Math/abs (- x2 x1)) (Math/abs (- y2 y1))))


(defn iter-calculate
  [{:keys [infinite coords areas safe x y maxx minx maxy miny] :as results}]
  (if (<= y maxy)
    (let [dists (map (partial dist [x y]) coords)
          best (apply min dists)
          closest (.indexOf dists best)]
      (recur (cond-> results
               (inf? x y maxx minx maxy miny)
               (update :infinite conj closest)

               (only? best dists)
               (update-in [:areas closest] inc)

               (> maxx x)
               (update :x inc)

               (= maxx x)
               (assoc :x minx)

               (= maxx x)
               (update :y inc)

               (> 10000 (reduce + dists))
               (update :safe inc))))
    results))

(defn display-results
  [{:keys [areas infinite safe]}]
    (let [areas (map-indexed (fn [idx x] (if (contains? infinite idx) 0 x)) 
                             areas)
          largest (apply max areas)]
      (println "largest:" largest)
      (println "safe" safe)))

(defn calculate
  [coords]
  (let [xs (map first coords)
        ys (map last coords)
        minx (apply min xs)
        maxx (apply max xs)
        miny (apply min ys)
        maxy (apply max ys)]
    (display-results (iter-calculate {:infinite #{}
                                      :coords coords
                                      :areas (into [] (map (fn [_] 0) coords))
                                      :x minx
                                      :y miny
                                      :safe 0
                                      :maxx maxx
                                      :minx minx
                                      :maxy maxy
                                      :miny miny}))))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!")
  (calculate real-coords)) 
