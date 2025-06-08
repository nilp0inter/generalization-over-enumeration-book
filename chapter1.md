# Chapter 1: Introduction to Property-Based Testing

Property-based testing is a methodology where instead of providing specific input-output examples, we describe general properties that should hold for all valid inputs. The testing framework then generates many random inputs to verify these properties.

## The Traditional Approach

Let's start with a simple function that reverses a list:

```{code-cell} python
def reverse_list(lst):
    """Reverse a list in place and return it."""
    return lst[::-1]
```

Traditional unit testing might look like this:

```{code-cell} python
def test_reverse_list_traditional():
    assert reverse_list([1, 2, 3]) == [3, 2, 1]
    assert reverse_list([]) == []
    assert reverse_list([42]) == [42]
    print("All traditional tests passed!")

test_reverse_list_traditional()
```

This approach has limitations:
- We only test specific cases we think of
- We might miss edge cases
- Tests don't express the mathematical properties of reversal

## The Property-Based Approach

With Hypothesis, we can express properties that should always hold:

```{code-cell} python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_reverse_twice_is_identity(lst):
    """Reversing a list twice should give the original list."""
    assert reverse_list(reverse_list(lst)) == lst

@given(st.lists(st.integers()))
def test_reverse_preserves_length(lst):
    """Reversing a list should preserve its length."""
    assert len(reverse_list(lst)) == len(lst)

@given(st.lists(st.integers(), min_size=1))
def test_reverse_first_becomes_last(lst):
    """The first element becomes the last after reversal."""
    reversed_lst = reverse_list(lst)
    assert lst[0] == reversed_lst[-1]

# Run the property-based tests
test_reverse_twice_is_identity()
test_reverse_preserves_length()
test_reverse_first_becomes_last()
print("All property-based tests passed!")
```

## What Makes This Powerful?

Property-based tests express mathematical relationships:

1. **Involution**: `reverse(reverse(x)) = x`
2. **Length preservation**: `len(reverse(x)) = len(x)`
3. **Element mapping**: First element maps to last position

```{code-cell} python
# Let's see Hypothesis in action with explicit examples
from hypothesis import example

@given(st.lists(st.integers()))
@example([])  # Explicitly test empty list
@example([1])  # Explicitly test single element
def test_reverse_comprehensive(lst):
    """Comprehensive test combining multiple properties."""
    original_length = len(lst)
    reversed_lst = reverse_list(lst)
    
    # Property 1: Length preservation
    assert len(reversed_lst) == original_length
    
    # Property 2: Double reversal is identity
    assert reverse_list(reversed_lst) == lst
    
    # Property 3: If non-empty, first becomes last
    if lst:
        assert lst[0] == reversed_lst[-1]
        assert lst[-1] == reversed_lst[0]

test_reverse_comprehensive()
print("Comprehensive property test passed!")
```

## Benefits of This Approach

- **Automatic test case generation**: Hypothesis generates diverse inputs
- **Mathematical precision**: Properties express exact behavioral requirements
- **Better coverage**: Tests edge cases we might not think of
- **Self-documenting**: Properties serve as specifications

In the following chapters, we'll explore more sophisticated properties and learn how to apply this thinking to complex real-world code.