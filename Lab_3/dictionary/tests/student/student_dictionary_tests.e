note
	description: "Summary description for {STUDENT_DICTIONARY_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_DICTIONARY_TESTS

inherit
	ES_TEST
	redefine
		setup, teardown
	end

create
	make

feature
	make

	do
		create d.make
		check d.count = 0 end

		add_boolean_case (agent test_array_comparison)
		add_boolean_case (agent test_get_keys_mine)
	end

feature
	d: DICTIONARY[STRING, INTEGER]

	setup
		do
			d.add_entry("A", 1)
--			d.add_entry("Bob", 14)
--			d.add_entry("Eve", 21)
		end

	teardown
		do
			create d.make
		end

feature
	test_array_comparison:BOOLEAN
		local
			a1, a2:ARRAY[STRING]
		do
			comment("test: object_comparison feature")
			create a1.make_empty
			create a2.make_empty

			a1.force ("Abram", 1)
			a1.force ("Binyomin", 2)

			a2.force ("Abram", 1)
			a2.force ("Binyomin", 2)

			Result :=
				not a1.object_comparison
			and not a2.object_comparison
			and not (a1 ~ a2)
			check Result end

			a1.compare_objects
			a2.compare_objects
			Result :=
					a1.object_comparison
				and a2.object_comparison
				and a1 ~ a2
			check Result end
		end

	test_get_keys_mine:BOOLEAN
		local
			keys:ARRAY[INTEGER]
		do
			comment("see if get_keys works")
			create keys.make_empty
			--d.add_entry ("A", 1)
			d.add_entry ("B", 2)
			d.add_entry ("C", 3)
			d.add_entry ("D", 4)
			d.add_entry ("A", 5)
			across
				d.get_keys ("A") as k
			loop
				keys.force (k.item, keys.count+1)
			end
			Result :=
				keys.count = 2
			and keys[1] = 1
			and keys[2] = 5
			check Result end
		end

end
