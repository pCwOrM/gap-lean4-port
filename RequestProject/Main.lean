import Mathlib
import RequestProject.Gap.Permutation
import RequestProject.Gap.Atlas
import RequestProject.Gap.Library.Zmodnz
import RequestProject.Gap.Library.Partitio
import RequestProject.Gap.Library.Zmodnze
import RequestProject.Gap.Library.Stbc
import RequestProject.Gap.Library.Grpperm

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
## Demonstration of the GAP permutation port
-/

namespace GAP.GapPerm

/-- The transposition swapping the points `0` and `1` (degree 2). -/
def swap01 : GapPerm := ⟨[1, 0], by decide⟩

example : swap01.app 0 = 1 := by decide
example : swap01.app 1 = 0 := by decide
example : swap01.app 5 = 5 := by decide

example (i : Nat) : (mul swap01 swap01).app i = i := by
  rw [app_mul]
  rcases lt_or_ge i 2 with h | h
  · interval_cases i <;> decide
  · have hfix : swap01.app i = i := app_of_ge h
    rw [hfix, hfix]

example (i : Nat) : (inv swap01).app i = swap01.app i := by
  rcases lt_or_ge i 2 with h | h
  · interval_cases i <;> decide
  · rw [app_of_ge (show (inv swap01).deg ≤ i by simpa using h), app_of_ge h]

end GAP.GapPerm

/-!
## Demonstration of the ATLAS port
-/

namespace Atlas

example : Group.order (.alternating 5) = 60 := by decide

example : Group.order (.PSL 2 5) = Nat.card (alternatingGroup (Fin 5)) := by
  rw [← A5_card]; exact (iso_A5.2.2).symm

example : IsSimpleGroup (alternatingGroup (Fin 5)) := A5_isSimpleGroup

example :
    Group.order (.spor .M) =
      808017424794512875886459904961710757005754368000000000 := by decide

example : Sporadic.all.length = 26 := Sporadic.card_all

end Atlas

/-!
## Demonstration of the GAP ℤ/nℤ Modular Port (GAP-0331)
-/

namespace GAP.ZModnZObj

-- Cardinality of GAP's ℤ/6ℤ is exactly 6
example : Fintype.card (ZModnZObj 6) = 6 := by decide

-- Canonical representative of 14 mod 5 is 4
example : (ZModnZObj.ofNat (n := 5) 14).val = 4 := by rfl

-- Invertibility test: 5 is a unit in ℤ/6ℤ because gcd(5, 6) = 1
example : IsUnit (ZModnZObj.ofNat (n := 6) 5) := by
  rw [isUnit_iff]
  decide

-- Non-invertibility test: 4 is NOT a unit in ℤ/6ℤ because gcd(4, 6) = 2 ≠ 1
example : ¬ IsUnit (ZModnZObj.ofNat (n := 6) 4) := by
  rw [isUnit_iff]
  decide

end GAP.ZModnZObj

/-!
## Demonstration of GAP-0332: Ordered Partitions (lib/partitio.gi) & Cyclotomics (lib/zmodnze.gi)
-/

namespace GAP.Partitio

-- Disjointness of splitting [1, 2, 3] by even predicate
example : List.Disjoint (splitCellByPred [1, 2, 3] (fun x => x % 2 == 0)).1
                        (splitCellByPred [1, 2, 3] (fun x => x % 2 == 0)).2 :=
  splitCellByPred_disjoint [1, 2, 3] (fun x => x % 2 == 0)

end GAP.Partitio

namespace GAP.Zmodnze

-- Cardinality theorem: |(ℤ/3ℤ)(ε_2)| = 3^2 = 9
example : Fintype.card (ZmodnZepsObj 3 2) = 9 := by
  rw [ZmodnZepsObj.card_eq]
  decide

end GAP.Zmodnze

/-!
## Demonstration of GAP-0190: Permutation Groups & Group Order (lib/grpperm.gi)
-/

namespace GAP.Grpperm

open GAP.Stbc

-- Trivial group order: 1
example : (PermGroup.mk ([] : List (Equiv.Perm (Fin 4))) []).size = 1 := by
  decide

-- Two-level BSGS chain with basic orbits of size 3 and 2: Total order = 3 * 2 = 6 (S₃ / D₆)
example (L1 L2 : StabLevel (Fin 5))
    (h1 : L1.orbit.length = 3) (h2 : L2.orbit.length = 2) :
    (PermGroup.mk ([] : List (Equiv.Perm (Fin 5))) [L1, L2]).size = 6 := by
  dsimp [PermGroup.size, sizeStabChain, indicesStabChain]
  rw [h1, h2]
  rfl

end GAP.Grpperm


