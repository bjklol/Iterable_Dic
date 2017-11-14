note
	description: "Summary description for {ENTRY_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTRY_ITERATION_CURSOR[V, K]
inherit
	ITERATION_CURSOR[ENTRY[V,K]]

create
	make

feature
	make(va: ARRAY[V]; ll:LINKED_LIST[K])
	do
		values := va
		keys := ll
		position := keys.lower
	--	keys.start
	end

feature -- Access

	item: ENTRY[V,K]
			-- Item at current cursor position.
	local
		v:V
		k:K
	do
		v := values[position]
		k := keys[position]
		create Result.make (v, k)
		--Result := [v,k]
	end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			Result := position>keys.count
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			position := position + 1
		end

feature {NONE}
	values:ARRAY[V]
	keys: LINKED_LIST[K]
	position:INTEGER
end
