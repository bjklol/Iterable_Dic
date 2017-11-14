note
	description: "Entry in a dictionary consisting of a search key and a value."
	author: "Jackie and Your"
	date: "$Date$"
	revision: "$Revision$"

class
	ENTRY[V, K]  inherit ANY
	redefine
		is_equal
	end
create
	make

feature -- Attributes
	value: V
	key: K

feature -- Constructor
	make (v: V; k: K)
		do
			value := v
			key := k
		end

feature
	is_equal(other:like Current): BOOLEAN
	do
		Result := (current.key ~ other.key) and (current.value ~ other.value)
	end

	-- Your Task(done?)
	-- You may need to define/redefine feature(s) in this class.
end
