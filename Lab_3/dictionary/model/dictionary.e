note
	description: "A Dictionary ADT mapping from keys to values"
	author: "Jackie and You"
	date: "$Date$"
	revision: "$Revision$"

class
	DICTIONARY[V, K]

inherit ITERABLE[TUPLE[V,K]]

create
	make

feature {INSTRUCTOR_DICTIONARY_TESTS} -- Do not modify this export status!
	-- You are required to implement all dictionary features using these two attributes.
	values: ARRAY[V]
	keys: LINKED_LIST[K]

feature -- Feature(s) required by ITERABLE
	-- Your Task
	-- See test_iterable_dictionary and test_iteration_cursor in INSTRUCTOR_DICTIONARY_TESTS.
	-- As soon as you make the current class iterable,
	-- define the necessary feature(s) here.
	new_cursor: ITERATION_CURSOR [TUPLE[V,K]] -- Fresh cursor associated with current structure
		local
			t: TUPLE_ITERATION_CURSOR[V,K]
		do
			create t.make(values,keys)
			Result := t
		end



feature -- Alternative Iteration Cursor
	another_cursor: ITERATION_CURSOR[ENTRY[V,K]]
	local
		e:ENTRY_ITERATION_CURSOR[V,K]
	do
		create e.make(values,keys)
		Result := e
	end
	-- See test_another_cursor in INSTRUCTOR_DICTIONARY_TESTS.
	-- A feature another_cursor is expected to be defined here.

feature -- Constructor
	make
			-- Initialize an empty dictionary.
		do
			create values.make_empty
			values.compare_objects
			create keys.make
			keys.compare_objects


		ensure
			empty_dictionary: values.is_empty and keys.is_empty -- Your task.
			object_equality_for_keys:
				keys.object_comparison
			object_equality_for_values:
				values.object_comparison
		end

feature -- Commands

	add_entry (v: V; k: K) -- letter , number
			-- Add a new entry with key 'k' and value 'v'.
			-- It is required that 'k' is not an existing search key in the dictionary.
		require
			non_existing_key: not exists(k) --keys: LINKED_LIST[K]
											--values: ARRAY[V]									
		do
			keys.force (k)	-- Your Task(done?)
			values.force (v, values.upper + 1)

		ensure
			entry_added:
			keys.at (count) = k
			values.at (values.count) = v
				-- Hint: In the new dictionary, the associated value of 'k' is 'v'
		end

	remove_entry (k: K)
			-- Remove the corresponding entry whose search key is 'k'.
			-- It is required that 'k' is an existing search key in the dictionary.
		require
			existing_key: exists(k) -- Your Task(done)
		local
			n:INTEGER
		do
			n := keys.index_of (k, 1)-- does this return an int?
			keys.go_i_th (n)
			keys.remove
			from
			until
				n=values.upper
			loop
				values[n] := values[n+1]
				n:=n+1
			end
			values.remove_tail (1)
		--	values.trim
		ensure
			dictionary_count_decremented:
				keys.count = (old keys.count) - 1 -- Your Task(done)
			key_removed: not keys.has (k)-- Your Task(done?)
		end

feature -- Queries

	count: INTEGER
			-- Number of entries in the dictionary.
		do
			Result := keys.count-- Your Task(done?)
		ensure
			correct_result: Result = keys.count -- Your Task(done?)
		end

	exists (k: K): BOOLEAN
			-- Does key 'k' exist in the dictionary?
		do
			Result := keys.has (k)
		ensure
			correct_result: (Result = true) implies (keys.has (k) = true)
			(Result = false) implies (keys.has (k) = false)
		end


	get_keys (v: V): ITERABLE[K]
			-- Return an iterable collection of keys that are associated with value 'v'.
			-- Hint: Refer to the architecture BON diagram of the Iterator Pattern, to see
			-- what classes can be used to instantiate objects that are iterable. -- we have keys as a linkedlist given to us already
		local
			n:INTEGER
			l:LINKED_LIST[K]
			amount:INTEGER
		do
			create l.make
			amount := 0
			from
				n := 1
			until
				n = keys.count + 1
			loop
				if values[n] ~ v and (exists(keys.at(n)))  then
					l.extend(keys.at(n))
					amount:= amount + 1
				end
				n := n+1
			end
			 Result := l -- Your Task(can use ARRAY, ARRAYLIST, or LINKEDLIST)
		ensure
			correct_result: -- Your Task(done?)
				across Result as i
					all  values[keys.index_of(i.item,1)] ~ v
				end
				
				-- Hint: Since Result is iterable, go accross it and make sure
				-- that every key in that iterable collection has its corresponding
				-- value equal to 'v'. Remember that in this naive implementation
				-- strategy, an existing key and its associated value have the same index.
		end

	get_value (k: K): detachable V
			-- Return the assocated value of search key 'k' if it exists.
			-- Void if 'k' does not exist.
			-- Declaring "detachable" besides the return type here indicates that
			-- the return value might be void (i.e., null).
		local
			n:INTEGER
		do
			if (keys.has (k)) then
				n := keys.index_of (k, 1)
				Result := values.at (n)
			end

		ensure
			case_of_void_result:
			(not keys.has (k)) implies (Result = void) --(done?)
				-- Hint: What does it mean when the return value is void?
			case_of_non_void_result: -- Your Task(done?)
			(keys.has (k)) implies not(Result = void)
				-- Hint: What does it mean when the return value is not void?
		end

invariant
	consistent_counts_of_keys_and_values:
		keys.count = values.count
	consistent_counts_of_imp_and_adt:
		keys.count = count and values.count = count
end
