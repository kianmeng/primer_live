defmodule PrimerLive.Helpers.AttributeHelpers do
  @moduledoc false

  alias PrimerLive.Helpers.FormHelpers

  @doc ~S"""
  Concatenates a list of classnames to a single string.
  - Ignores any nil or false entries
  - Removes duplicate entries
  - Trims whitespaces
  Returns nil if the resulting output is an empty string.

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.classnames([])
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.classnames([""])
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.classnames(["foo   ", nil, "  bar  ", false])
      "foo bar"

      iex> PrimerLive.Helpers.AttributeHelpers.classnames(["foo", nil, "  foo  "])
      "foo"

      iex> is_foo = true
      iex> is_bar = false
      iex> PrimerLive.Helpers.AttributeHelpers.classnames([
      ...>   is_foo and "foo",
      ...>   is_bar and "bar"
      ...> ])
      "foo"
  """
  def classnames(input_classnames) do
    concat(input_classnames, " ")
  end

  def inline_styles(input_styles) do
    concat(input_styles, "; ")
  end

  defp concat(list, joiner) do
    result =
      list
      |> Enum.reject(&(is_nil(&1) || &1 == false || &1 == ""))
      |> Enum.map(&String.trim(&1))
      |> Enum.uniq()
      |> Enum.join(joiner)

    if result == "" do
      nil
    else
      result
    end
  end

  @doc ~S"""
  Concatenates 2 keyword lists of attributes.
  - Ignores any nil or false entries
  - Removes duplicate entries

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes([], [[]])
      []

      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes([[]])
      []

      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes([dir: "rtl"], [[]])
      [dir: "rtl"]

      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes([dir: "rtl"], [[placeholder: "hello"]])
      [dir: "rtl", placeholder: "hello"]

      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes([dir: "rtl"], [false, [placeholder: "hello"], [placeholder: "hello"], nil])
      [dir: "rtl", placeholder: "hello"]

      iex> is_foo = true
      iex> is_bar = false
      iex> extra = [class: "x"]
      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes(extra, [
      ...>   is_foo and [foo: "foo"],
      ...>   is_bar and [bar: "bar"]
      ...> ])
      [class: "x", foo: "foo"]

      iex> is_foo = true
      iex> is_bar = false
      iex> extra = %{class: "x"}
      iex> PrimerLive.Helpers.AttributeHelpers.append_attributes(extra, [
      ...>   is_foo and [foo: "foo"],
      ...>   is_bar and [bar: "bar"]
      ...> ])
      [class: "x", foo: "foo"]
  """
  def append_attributes(attributes, input_attributes) when is_map(attributes) do
    attr_list = Keyword.new(attributes)
    append_attributes(attr_list, input_attributes)
  end

  def append_attributes(attributes, input_attributes) do
    input_attributes
    |> Enum.reject(&(&1 == false || is_nil(&1)))
    |> Enum.uniq()
    |> Enum.reduce(attributes, fn kw, acc ->
      acc ++ kw
    end)
  end

  def append_attributes(input_attributes), do: append_attributes([], input_attributes)

  @doc ~S"""
  Converts user input to an integer, with optionally a default value

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.as_integer(nil)
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.as_integer("1")
      1

      iex> PrimerLive.Helpers.AttributeHelpers.as_integer(2)
      2

      iex> PrimerLive.Helpers.AttributeHelpers.as_integer(2.0)
      2

      iex> PrimerLive.Helpers.AttributeHelpers.as_integer("x")
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.as_integer("x", 42)
      42
  """
  def as_integer(input, default_value \\ nil)
  def as_integer(input, _default_value) when is_integer(input), do: input
  def as_integer(input, _default_value) when is_float(input), do: trunc(input)

  def as_integer(input, default_value) when is_binary(input) do
    try do
      String.to_integer(input)
    rescue
      ArgumentError -> default_value
    end
  end

  def as_integer(_input, default_value), do: default_value

  @doc ~S"""
  Converts user input to a boolean, with optionally a default value

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(true)
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("true")
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("1")
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(1)
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(1.0)
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(false)
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("false")
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("0")
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(0)
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(0.0)
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("x")
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("100")
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("100.0")
      true

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean("0.1")
      false

      iex> PrimerLive.Helpers.AttributeHelpers.as_boolean(%{})
      false

  """
  def as_boolean(input, default_value \\ false)
  def as_boolean(input, _default_value) when is_boolean(input), do: input

  def as_boolean(input, _default_value) when is_binary(input) and input === "true", do: true
  def as_boolean(input, _default_value) when is_binary(input) and input === "1", do: true
  def as_boolean(input, _default_value) when is_binary(input) and input === "false", do: false
  def as_boolean(input, _default_value) when is_binary(input) and input === "0", do: false

  def as_boolean(input, default_value) when is_binary(input) do
    case Integer.parse(input) do
      {int, _rest} -> as_boolean(int, default_value)
      _ -> default_value
    end
  end

  def as_boolean(input, _default_value) when is_number(input) do
    if input > 0 do
      true
    else
      false
    end
  end

  def as_boolean(_input, default_value), do: default_value

  @doc """
  Takes 2 lists and padds the shortest list with placeholder values.

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.pad_lists([], [])
      [[], []]

      iex> PrimerLive.Helpers.AttributeHelpers.pad_lists([1, 2, 3], [])
      [[1, 2, 3], [:placeholder, :placeholder, :placeholder]]

      iex> PrimerLive.Helpers.AttributeHelpers.pad_lists([], [1, 2, 3])
      [[:placeholder, :placeholder, :placeholder], [1, 2, 3]]

      iex> PrimerLive.Helpers.AttributeHelpers.pad_lists([1], [1, 2])
      [[1, :placeholder], [1, 2]]

      iex> PrimerLive.Helpers.AttributeHelpers.pad_lists([], [1, 2, 3], 0)
      [[0, 0, 0], [1, 2, 3]]

      iex> header_slot = []
      iex> header_title_slot = [%{
      ...>   __slot__: :header_title,
      ...>   inner_block: "Title content"
      ...> }]
      iex> Enum.zip(PrimerLive.Helpers.AttributeHelpers.pad_lists(header_slot, header_title_slot, []))
      [{[], %{__slot__: :header_title, inner_block: "Title content"}}]

  """
  def pad_lists(list1, list2, padding \\ :placeholder) do
    case Enum.count(list1) > Enum.count(list2) do
      true ->
        [
          list1,
          pad_list(list1, list2, padding)
        ]

      false ->
        [
          pad_list(list2, list1, padding),
          list2
        ]
    end
  end

  defp pad_list(longest, shortest, padding) do
    longest
    |> Enum.with_index()
    |> Enum.map(fn {_, idx} -> Enum.at(shortest, idx) || padding end)
  end

  @doc """
  Forces a value to be within a min and max value.any()

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.minmax(-1, 0, 2)
      0

      iex> PrimerLive.Helpers.AttributeHelpers.minmax(3, 0, 2)
      2

      iex> PrimerLive.Helpers.AttributeHelpers.minmax(0, 0, 0)
      0

      iex> PrimerLive.Helpers.AttributeHelpers.minmax(1, 0, 0)
      0

  """
  def minmax(value, min, max) do
    max(min, min(value, max))
  end

  @doc """
  Generates a random string.
  """
  def random_string(), do: Ecto.UUID.generate()

  @doc """
  Verifies if a slot should be handled as a link.

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.is_link?(%{href: "#url"})
      true

      iex> PrimerLive.Helpers.AttributeHelpers.is_link?(%{navigate: "#url"})
      true

      iex> PrimerLive.Helpers.AttributeHelpers.is_link?(%{patch: "#url"})
      true

      iex> PrimerLive.Helpers.AttributeHelpers.is_link?(%{url: "#url"})
      false
  """
  def is_link?(assigns), do: !!link_url(assigns)

  defp link_url(assigns), do: assigns[:href] || assigns[:navigate] || assigns[:patch]

  @doc """
  Verifies if a slot should be handled as a link.

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.is_anchor_link?(%{})
      false

      iex> PrimerLive.Helpers.AttributeHelpers.is_anchor_link?(%{href: "/url"})
      false

      iex> PrimerLive.Helpers.AttributeHelpers.is_anchor_link?(%{href: "url"})
      false

      iex> PrimerLive.Helpers.AttributeHelpers.is_anchor_link?(%{href: "#url"})
      true
  """
  def is_anchor_link?(assigns) do
    link_url(assigns) |> is_anchor_link_url?()
  end

  defp is_anchor_link_url?(url) when is_nil(url), do: false

  defp is_anchor_link_url?(url) do
    String.match?(url, ~r/^#/)
  end

  @doc """
  Generates the input name of a form field, using `Phoenix.HTML.Form.input_name/2` with support for multiple inputs (e.g. checkboxes).
  Param opts accepts
  - name: the field name
  - is_multiple

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(nil, nil)
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.input_name("my-form", nil)
      "my-form"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name("my-form", "field")
      "my-form[field]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(:form, nil)
      "form"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(nil, "my-field")
      "[my-field]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(nil, :first_name)
      "[first_name]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(:profile, :first_name)
      "profile[first_name]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(nil, nil, name: "my-first-name")
      "my-first-name"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(:profile, nil, name: "my-first-name")
      "profile[my-first-name]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(:profile, :first_name, name: "my-first-name")
      "profile[my-first-name]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_name(:profile, :first_name, is_multiple: true)
      "profile[first_name][]"
  """

  def input_name(form, field, opts \\ []) do
    _input_name(form, field, opts[:name], !!opts[:is_multiple])
  end

  defp _input_name(form, field, name, _is_multiple) when is_nil(form) and is_nil(field),
    do: name

  defp _input_name(form, field, name, is_multiple) do
    single_input_name =
      Phoenix.HTML.Form.input_name(form, name || field || "")
      |> String.replace(~r/(\[\])+$/, "")

    cond do
      is_multiple && single_input_name !== "" -> single_input_name <> "[]"
      single_input_name !== "" -> single_input_name
      true -> nil
    end
  end

  @doc """
  Generates the input id of a form field.

  ## Tests

      iex> PrimerLive.Helpers.AttributeHelpers.input_id("my-input-id", nil, nil, "", nil)
      "my-input-id"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, "my-id", nil, "", nil)
      "my-id"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :select, "", nil)
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :select, "[my-input-name]", nil)
      "[my-input-name]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :select, "[my-input-name][]", nil)
      "[my-input-name]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :checkbox, "", nil)
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :checkbox, "my-input-name", nil)
      "my-input-name"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :checkbox, "my-input-name", "my-value")
      "my-input-name[my-value]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :checkbox, "[my-input-name]", "my-value")
      "[my-input-name][my-value]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :checkbox, "[my-input-name][]", "my-value")
      "[my-input-name][my-value]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :checkbox, "[my-input-name][]", nil)
      "[my-input-name][]"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :radio_button, "", nil)
      nil

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :radio_button, "my-input-name", nil)
      "my-input-name"

      iex> PrimerLive.Helpers.AttributeHelpers.input_id(nil, nil, :radio_button, "my-input-name", "my-value")
      "my-input-name[my-value]"

  """
  def input_id(input_id, _id, _input_type, _input_name, _value_for_derived_label)
      when not is_nil(input_id),
      do: input_id

  def input_id(_input_id, id, _input_type, _input_name, _value_for_derived_label)
      when not is_nil(id),
      do: id

  def input_id(_input_id, _id, input_type, "", _value_for_derived_label)
      when input_type === :select,
      do: nil

  def input_id(_input_id, _id, input_type, input_name, _value_for_derived_label)
      when input_type === :select,
      do: input_name |> String.replace(~r/\[\]$/, "")

  def input_id(_input_id, _id, input_type, "", value_for_derived_label)
      when input_type === :checkbox or input_type === :radio_button,
      do: value_for_derived_label

  def input_id(_input_id, _id, input_type, input_name, value_for_derived_label)
      when (input_type === :checkbox or input_type === :radio_button) and is_binary(input_name) do
    cond do
      String.match?(input_name, ~r/\[\]$/) ->
        String.replace(input_name, ~r/(\[\]$)/, "[#{value_for_derived_label}]")

      !is_nil(value_for_derived_label) ->
        "#{input_name}[#{value_for_derived_label}]"

      true ->
        input_name
    end
  end

  def input_id(_input_id, _id, _input_type, "", _value_for_derived_label), do: nil
  def input_id(_input_id, _id, _input_type, input_name, _value_for_derived_label), do: input_name

  @doc ~S"""
  Extracts common attributes for form inputs. Shared for consistency.
  """
  def common_input_attrs(assigns, input_type) do
    rest = assigns[:rest]
    name = assigns[:name] || rest[:name]
    id = rest[:id]
    form = assigns[:form]
    field = assigns[:field]
    field_or_name = field || name || ""
    is_multiple = !!assigns[:is_multiple]

    input_name =
      if !is_nil(form) || !is_nil(field),
        do: input_name(form, field, name: name, is_multiple: is_multiple),
        else: name

    phx_feedback_for_id = input_name

    # Get value from checkbox or radio button

    checked_value = assigns[:checked_value]
    value = assigns[:value] || rest[:value]
    value_for_derived_label = checked_value || value

    derived_label =
      case input_type do
        :checkbox -> Phoenix.HTML.Form.humanize(value_for_derived_label || field)
        :radio_button -> Phoenix.HTML.Form.humanize(value_for_derived_label)
        _ -> nil
      end

    input_id = input_id(assigns[:input_id], id, input_type, input_name, value_for_derived_label)

    # Form group

    form_group = assigns[:form_group]
    is_form_group = assigns[:is_form_group]
    has_form_group = is_form_group || form_group

    form_group_attrs =
      Map.merge(form_group || %{}, %{
        form: form,
        field: field_or_name,
        for: input_id
      })

    # Field state
    validation_message = assigns[:validation_message]
    field_state = FormHelpers.field_state(form, field_or_name, validation_message)

    %{
      message: message,
      valid?: valid?,
      ignore_errors?: ignore_errors?
    } = field_state

    has_changeset = !is_nil(field_state.changeset)
    show_message? = !!message && !ignore_errors? && assigns[:type] !== "hidden"
    validation_message_id = if !is_nil(field_state.message), do: "#{input_id}-validation"

    ## Phoenix uses phx_feedback_for to hide form field errors that are untouched.
    ## However, this attribute can't be set on the element itself (the JS DOM library stalls).
    ## Element "validation_marker" is used as stopgap: a separate element placed just before the input element.
    validation_marker_attrs =
      case has_changeset do
        true ->
          [
            phx_feedback_for: input_id,
            class:
              if valid? do
                "pl-valid"
              else
                "pl-invalid"
              end
          ]

        false ->
          nil
      end

    %{
      # Common
      rest: rest,
      form: form,
      field: field,
      # ID and label
      input_name: input_name,
      input_id: input_id,
      phx_feedback_for_id: phx_feedback_for_id,
      value: value,
      derived_label: derived_label,
      validation_message_id: validation_message_id,
      # Form group
      has_form_group: has_form_group,
      form_group_attrs: form_group_attrs,
      # Field state
      message: message,
      valid?: valid?,
      ignore_errors?: ignore_errors?,
      show_message?: show_message?,
      validation_marker_attrs: validation_marker_attrs
    }
  end
end
