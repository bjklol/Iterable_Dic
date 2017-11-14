note
	description: "Test the Dictionary ADT"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_DICTIONARY

inherit
	ES_SUITE

create
	make

feature -- Add test classes
	make
		do
			add_test (create {INSTRUCTOR_DICTIONARY_TESTS}.make)
			add_test (create {STUDENT_DICTIONARY_TESTS}.make)
			show_browser
			run_espec
		end
end
