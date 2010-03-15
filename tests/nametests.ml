open OUnit
open Name

let todo_func = function
      _ -> todo "Not implemented"

let nametests = TestLabel(
                    "nametests",
                    TestList([
                        TestLabel(
                            "todo",
                            TestCase(todo_func)
                        )
                    ])
                )

let _ =
    run_test_tt nametests
