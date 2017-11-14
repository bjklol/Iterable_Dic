note
	description: "Requirements Tests for DICTIONARY"
	date: "$Date$"
	revision: "$Revision$"

class
	INSTRUCTOR_DICTIONARY_TESTS

inherit
	ES_TEST
		redefine
			setup, teardown
		end

create
	make

feature  -- Add tests

	make
			-- Run application.
		do
			create d.make
			check d.count = 0 end

			add_boolean_case (agent test_array_comarison)
			add_boolean_case (agent test_setup)
			add_boolean_case (agent test_get_keys)
			add_boolean_case (agent test_remove)
			add_boolean_case (agent test_iterable_dictionary)
			add_boolean_case (agent test_iteration_cursor)
			add_boolean_case (agent test_another_cursor)
		end

feature -- Setup
	d: DICTIONARY[STRING, INTEGER]

	setup
			-- Initialize 'd' as a 4-entry dictionary.
			-- This feature is executed in the beginning of every test feature.
		do
			d.add_entry ("A", 1)
			d.add_entry ("B", 2)
			d.add_entry ("C", 3)
			d.add_entry ("D", 4)
		end

	teardown
			-- Recreate 'd' as an empty dictionary.
			-- This feature is executed at end of every test feature.
		do
			create d.make
		end

feature -- Tests
	test_array_comarison: BOOLEAN
		local
			a1, a2: ARRAY[STRING]
		do
			comment ("test_array_comparison: test ref. and obj. comparison")
			create a1.make_empty
			create a2.make_empty
			a1.force ("A", 1)
			a1.force ("B", 2)
			a1.force ("C", 3)

			a2.force ("A", 1)
			a2.force ("B", 2)
			a2.force ("C", 3)

			Result :=
						not a1.object_comparison
				and	not a2.object_comparison
				and 	not (a1 ~ a2)
			check Result end

			a1.compare_objects
			a2.compare_objects
			Result :=
						a1.object_comparison
				and	a2.object_comparison
				and 	a1 ~ a2
		end

	test_setup: BOOLEAN
		do
			comment ("test_setup: test the initial dictionary")
			Result :=
						d.count = 4
				and	d.get_value (1) ~ "A"
				and	d.get_value (2) ~ "B"
				and	d.get_value (3) ~ "C"
				and	d.get_value (4) ~ "D"
				and	d.get_value (5) ~ Void
		end

	test_remove: BOOLEAN
		do
			comment ("test_remove: test entry removal")
			d.remove_entry (2)
			Result :=
						d.count = 3
				and	d.get_value (1) ~ "A"
				and	d.get_value (3) ~ "C"
				and	d.get_value (4) ~ "D"
		end

	test_get_keys: BOOLEAN
		local
			keys: ARRAY[INTEGER]
		do
			comment ("test_get_keys: test iterable keys")
			create keys.make_empty
			d.add_entry ("A", 5)

			create keys.make_empty
			across
				d.get_keys ("A") as k
			loop
				keys.force (k.item, keys.count + 1)
			end
			Result :=
						keys.count = 2
				 and	keys[1] = 1
				 and 	keys[2] = 5
			check Result end
		end

	test_iterable_dictionary: BOOLEAN
		local
			tuples: ARRAY[TUPLE[STRING, INTEGER]]
		do
			comment ("test_iterable_dictionary: test iterating through dictionary")
			create tuples.make_empty
			across
				d as tuple
			loop
				tuples.force (tuple.item, tuples.count + 1)
			end
			Result :=
						tuples.count = 4
				 and	tuples [1].item (1) ~ "A" and tuples[1].item (2) = 1
				 and	tuples [2].item (1) ~ "B" and tuples[2].item (2) = 2
				 and	tuples [3].item (1) ~ "C" and tuples[3].item (2) = 3
				 and	tuples [4].item (1) ~ "D" and tuples[4].item (2) = 4
		end

	test_iteration_cursor: BOOLEAN
		local
			tic: TUPLE_ITERATION_CURSOR[STRING, INTEGER]
			tuples: ARRAY[TUPLE[STRING, INTEGER]]
		do
			comment ("test_iteration_cursor: test the returned cursor from dictionary")
			create tuples.make_empty
			check  attached {TUPLE_ITERATION_CURSOR[STRING, INTEGER]} d.new_cursor as nc then
				tic := nc
			end
			from
			until
				tic.after
			loop
				tuples.force (tic.item, tuples.count + 1)
				tic.forth
			end
			Result :=
						tuples.count = 4
				 and	tuples [1].item (1) ~ "A" and tuples[1].item (2) = 1
				 and	tuples [2].item (1) ~ "B" and tuples[2].item (2) = 2
				 and	tuples [3].item (1) ~ "C" and tuples[3].item (2) = 3
				 and	tuples [4].item (1) ~ "D" and tuples[4].item (2) = 4
		end

	test_another_cursor: BOOLEAN
		local
			eic: ENTRY_ITERATION_CURSOR[STRING, INTEGER]
			entries: ARRAY[ENTRY[STRING, INTEGER]]
		do
			comment ("test_another_cursor: test the alternative returned cursor from dictionary")
			create entries.make_empty

			-- This is a cast:
			-- Try to cast the expression 'd.another_cursor' to the type 'ENTRY_ITERATION_CURSOR[STRING, INTEGER]'
			-- If the cast succeeds, then assign the cast object to 'nc'.
			-- Otherwise, fail the cast as a check assertion violation.
			check  attached {ENTRY_ITERATION_CURSOR[STRING, INTEGER]} d.another_cursor as nc then
				eic := nc
			end
			from
			until
				eic.after
			loop
				entries.force (eic.item, entries.count + 1)
				eic.forth
			end
			Result :=
						entries.count = 4
				 and	entries [1] ~ (create {ENTRY[STRING, INTEGER]}.make ("A", 1))
				 and	entries [2] ~ (create {ENTRY[STRING, INTEGER]}.make ("B", 2))
				 and	entries [3] ~ (create {ENTRY[STRING, INTEGER]}.make ("C", 3))
				 and	entries [4] ~ (create {ENTRY[STRING, INTEGER]}.make ("D", 4))
		end
end
