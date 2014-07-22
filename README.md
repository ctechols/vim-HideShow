# HideShow.vim

HideShow makes it easy to apply regex based folding to your vim buffer.  
For example, a trivial folding of a Java source file might be:

```VimL
:Show \v(public|private|protected)
```

:Show and :Hide invocations are cumulative, so the following three 
invocations of :Show are equivalent to the single command above:

```VimL
:Show public
:Show protected
:Show private
```

`:Show` and `:Hide` invocations work together.  So to naively show all 
class field declarations:

```VimL
:Show \v^\s*(public|private|protected).*;$
```

Now, all 'String' fields can be folded away with:

```VimL
:Hide String
```

Once folds are no longer needed:

```
:ShowAll
```

HideShow uses a fold expression to create its folds, so any new text
will be folded according to the commands already issued.

HideShow is meant to be a simple, quick-and-dirty way to create, refine, 
and clear folding when pre-defined fold methods for a filetype are 
non-existent or suboptimal.  The folds aren't the pretty, nested, 
syntax-aware folds that are created in something like eclipse, but they 
are simple and effective.

# Installation

Just clone the repo into your pathogen bundle directory.
