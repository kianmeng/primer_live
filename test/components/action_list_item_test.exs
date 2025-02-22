defmodule PrimerLive.TestComponents.ActionListItemTest do
  use ExUnit.Case
  use PrimerLive
  import PrimerLive.Helpers.TestHelpers

  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "Slot: inner_block" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item>
             Content
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item">
             <span class="ActionList-content">
             <span class="ActionList-item-label">Content</span>
             </span>
             </li>
             """
             |> format_html()
  end

  test "Slot: link" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_selected>
             <:link href="/url" target="_blank">
               href link
             </:link>
           </.action_list_item>
           <.action_list_item>
             <:link navigate="/url">
               navigate link
             </:link>
           </.action_list_item>
           <.action_list_item>
             <:link patch="/url">
               patch link
             </:link>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item ActionList-item--navActive" role="none"><a href="/url" aria-current="page" aria-selected="true" class="ActionList-content" role="menuitem" target="_blank"><span class="ActionList-item-label">href link</span></a></li>
             <li class="ActionList-item" role="none"><a href="/url" data-phx-link="redirect" data-phx-link-state="push" class="ActionList-content" role="menuitem"><span class="ActionList-item-label">navigate link</span></a></li>
             <li class="ActionList-item" role="none"><a href="/url" data-phx-link="patch" data-phx-link-state="push" class="ActionList-content" role="menuitem"><span class="ActionList-item-label">patch link</span></a></li>
             """
             |> format_html()
  end

  test "Link attributes (anchor links)" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_selected>
             <:link href="#url">
               href link
             </:link>
           </.action_list_item>
           <.action_list_item>
             <:link navigate="#url">
               navigate link
             </:link>
           </.action_list_item>
           <.action_list_item>
             <:link patch="#url">
               patch link
             </:link>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item ActionList-item--navActive" role="none"><a href="#url" aria-current="location" aria-selected="true" class="ActionList-content" role="menuitem"><span class="ActionList-item-label">href link</span></a></li>
             <li class="ActionList-item" role="none"><a href="#url" data-phx-link="redirect" data-phx-link-state="push" class="ActionList-content" role="menuitem"><span class="ActionList-item-label">navigate link</span></a></li>
             <li class="ActionList-item" role="none"><a href="#url" data-phx-link="patch" data-phx-link-state="push" class="ActionList-content" role="menuitem"><span class="ActionList-item-label">patch link</span></a></li>
             """
             |> format_html()
  end

  test "Attribute: is_button" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_button phx-click="remove">
             Button
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li phx-click="remove" class="ActionList-item">
             <button class="ActionList-content"><span class="ActionList-item-label">Button</span></button>
             </li>
             """
             |> format_html()
  end

  test "Attribute: is_selected" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_selected>
             <:link href="/url">
               Item
             </:link>
           </.action_list_item>
           <.action_list_item is_selected>
             Item
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item ActionList-item--navActive" role="none"><a href="/url" aria-current="page" aria-selected="true" class="ActionList-content" role="menuitem"><span class="ActionList-item-label">Item</span></a></li>
             <li class="ActionList-item ActionList-item--navActive" aria-selected="true"><span class="ActionList-content"><span class="ActionList-item-label">Item</span></span></li>
             """
             |> format_html()
  end

  test "Attributes: is_danger, is_disabled, is_truncated" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_danger>
             Item
           </.action_list_item>
           <.action_list_item is_disabled>
             Item
           </.action_list_item>
           <.action_list_item is_truncated>
             Very long label
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item ActionList-item--danger"><span class="ActionList-content"><span class="ActionList-item-label">Item</span></span></li>
             <li class="ActionList-item" aria-disabled="true"><span class="ActionList-content"><span class="ActionList-item-label">Item</span></span></li>
             <li class="ActionList-item"><span class="ActionList-content"><span class="ActionList-item-label ActionList-item-label--truncate">Very long label</span></span></li>
             """
             |> format_html()
  end

  test "Attribute: is_single_select" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_single_select is_selected>
             Item
           </.action_list_item>
           <.action_list_item is_single_select>
             Item
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item" aria-selected="true" role="option">
             <span class="ActionList-content">
             <span class="ActionList-item-visual ActionList-item-visual--leading">
             <span class="FormControl-checkbox-wrap ActionList-item-singleSelectCheckmark">
             <input checked class="FormControl-checkbox" type="checkbox" value="true" />
             </span>
             </span>
             <span class="ActionList-item-label">Item</span>
             </span>
             </li>
             <li class="ActionList-item" aria-selected="false" role="option">
             <span class="ActionList-content">
             <span class="ActionList-item-visual ActionList-item-visual--leading">
             <span class="FormControl-checkbox-wrap ActionList-item-singleSelectCheckmark">
             <input class="FormControl-checkbox" type="checkbox" value="true" />
             </span>
             </span>
             <span class="ActionList-item-label">Item</span>
             </span>
             </li>
             """
             |> format_html()
  end

  test "Attribute: is_single_select (custom visual)" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_single_select is_selected>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
           </.action_list_item>
           <.action_list_item is_single_select>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item" aria-selected="true" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span></span></li>
             <li class="ActionList-item" aria-selected="false" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span></span></li>
             """
             |> format_html()
  end

  test "Attribute: is_multiple_select" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_multiple_select is_selected>
             Item
           </.action_list_item>
           <.action_list_item is_multiple_select>
             Item
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item" aria-selected="true" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading"><span class="FormControl-checkbox-wrap ActionList-item-multiSelectIcon">
             <input checked class="FormControl-checkbox" type="checkbox" value="true" /></span></span><span class="ActionList-item-label">Item</span></span></li>
             <li class="ActionList-item" aria-selected="false" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading"><span class="FormControl-checkbox-wrap ActionList-item-multiSelectIcon">
             <input class="FormControl-checkbox" type="checkbox" value="true" /></span></span><span class="ActionList-item-label">Item</span></span></li>
             """
             |> format_html()
  end

  test "Attribute: is_multiple_select (custom visual)" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_multiple_select is_selected>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
           </.action_list_item>
           <.action_list_item is_multiple_select>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item" aria-selected="true" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span></span></li>
             <li class="ActionList-item" aria-selected="false" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span></span></li>
             """
             |> format_html()
  end

  test "Attribute: is_multiple_select with is_checkmark_icon" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_multiple_select is_checkmark_icon is_selected>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
           </.action_list_item>
           <.action_list_item is_multiple_select is_checkmark_icon>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item" aria-selected="true" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span></span></li>
             <li class="ActionList-item" aria-selected="false" role="option"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span></span></li>
             """
             |> format_html()
  end

  test "Attribute: is_collapsible, is_expanded" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_collapsible is_expanded>
             Item
           </.action_list_item>
           <.action_list_item is_collapsible>
             Item
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item"><button class="ActionList-content" aria-expanded="true"><span class="ActionList-item-label">Item</span><span class="ActionList-item-visual ActionList-item-visual--trailing"><svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"
             aria-hidden="true" focusable="false" class="ActionList-item-collapseIcon">
             <path fill-rule="evenodd" d="M12.78 6.22a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06 0L3.22 7.28a.75.75 0 011.06-1.06L8 9.94l3.72-3.72a.75.75 0 011.06 0z"></path>
             </svg></span></button></li>
             <li class="ActionList-item"><button class="ActionList-content" aria-expanded="false"><span class="ActionList-item-label">Item</span><span class="ActionList-item-visual ActionList-item-visual--trailing"><svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"
             aria-hidden="true" focusable="false" class="ActionList-item-collapseIcon">
             <path fill-rule="evenodd" d="M12.78 6.22a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06 0L3.22 7.28a.75.75 0 011.06-1.06L8 9.94l3.72-3.72a.75.75 0 011.06 0z"></path>
             </svg></span></button></li>
             """
             |> format_html()
  end

  test "Attribute: is_collapsible, is_expanded (custom visual)" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_collapsible is_expanded>
             Item
             <:trailing_visual>
               Trailing visual
             </:trailing_visual>
           </.action_list_item>
           <.action_list_item is_collapsible>
             Item
             <:trailing_visual>
               Trailing visual
             </:trailing_visual>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item"><button class="ActionList-content" aria-expanded="true"><span class="ActionList-item-label">Item</span><span class="ActionList-item-visual ActionList-item-visual--trailing">Trailing visual</span></button></li>
             <li class="ActionList-item"><button class="ActionList-content" aria-expanded="false"><span class="ActionList-item-label">Item</span><span class="ActionList-item-visual ActionList-item-visual--trailing">Trailing visual</span></button></li>
             """
             |> format_html()
  end

  test "Sizes" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item>
             regular
           </.action_list_item>
           <.action_list_item is_height_medium>
             medium
           </.action_list_item>
           <.action_list_item is_height_large>
             large
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item"><span class="ActionList-content"><span class="ActionList-item-label">regular</span></span></li>
             <li class="ActionList-item"><span class="ActionList-content ActionList-content--sizeMedium"><span class="ActionList-item-label">medium</span></span></li>
             <li class="ActionList-item"><span class="ActionList-content ActionList-content--sizeLarge"><span class="ActionList-item-label">large</span></span></li>
             """
             |> format_html()
  end

  test "Slot: description" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item>
             Content
             <:description>
               A descriptive text
             </:description>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item">
             <span class="ActionList-content">
             <span class="ActionList-item-descriptionWrap ActionList-item-blockDescription">
             <span class="ActionList-item-label">Content</span>
             <span class="ActionList-item-description">A descriptive text</span>
             </span>
             </span>
             </li>
             """
             |> format_html()
  end

  test "Slot: description, attr is_inline_description" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item is_inline_description>
             Content
             <:description>
               A descriptive text
             </:description>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item">
             <span class="ActionList-content">
             <span class="ActionList-item-descriptionWrap ActionList-item-descriptionWrap--inline">
             <span class="ActionList-item-label">Content</span>
             <span class="ActionList-item-description">A descriptive text</span>
             </span>
             </span>
             </li>
             """
             |> format_html()
  end

  test "Slots: leading_visual and trailing_visual" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item>
             Item
             <:leading_visual>
               Icon
             </:leading_visual>
             <:trailing_visual>
               Trailing visual
             </:trailing_visual>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item"><span class="ActionList-content"><span class="ActionList-item-visual ActionList-item-visual--leading">Icon</span><span class="ActionList-item-label">Item</span><span class="ActionList-item-visual ActionList-item-visual--trailing">Trailing visual</span></span></li>
             """
             |> format_html()
  end

  test "Slot: sub_group" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_section_divider>
             <:title id="title-01">Section title</:title>
           </.action_list_section_divider>
           <.action_list_item>
             Not collapsible item, default expanded
             <:sub_group aria-labelledby="title-01">
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
             </:sub_group>
           </.action_list_item>
           <.action_list_section_divider>
             <:title>Section title</:title>
           </.action_list_section_divider>
           <.action_list_item leading_visual_width="16" is_collapsible>
             Collapsible, not expanded item
             <:leading_visual>
               <.octicon name="comment-discussion-16" />
             </:leading_visual>
             <:sub_group>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
             </:sub_group>
           </.action_list_item>
           <.action_list_section_divider>
             <:title>Section title</:title>
           </.action_list_section_divider>
           <.action_list_item leading_visual_width="16" is_collapsible is_expanded>
             Collapsible and expanded item
             <:leading_visual>
               <.octicon name="comment-discussion-16" />
             </:leading_visual>
             <:sub_group>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
             </:sub_group>
           </.action_list_item>
           <.action_list_section_divider>
             <:title>Section title</:title>
           </.action_list_section_divider>
           <.action_list_item leading_visual_width="24" is_collapsible is_expanded>
             Collapsible and expanded item, wide visual
             <:leading_visual>
               <.octicon name="comment-discussion-24" />
             </:leading_visual>
             <:sub_group>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
               <.action_list_item is_sub_item>
                 Sub item
               </.action_list_item>
             </:sub_group>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-sectionDivider">
             <h3 id="title-01" class="ActionList-sectionDivider-title">Section title</h3>
             </li>
             <li class="ActionList-item ActionList-item--hasSubItem"><span class="ActionList-content" aria-expanded="true"><span class="ActionList-item-label">Not collapsible item, default expanded</span></span>
             <ul aria-labelledby="title-01" class="ActionList ActionList--subGroup" role="list">
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             </ul>
             </li>
             <li class="ActionList-sectionDivider">
             <h3 class="ActionList-sectionDivider-title">Section title</h3>
             </li>
             <li class="ActionList-item ActionList-item--hasSubItem">
             <button class="ActionList-content ActionList-content--visual16" aria-expanded="false"><span class="ActionList-item-visual ActionList-item-visual--leading"><svg class="octicon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
             <path fill-rule="evenodd"
             d="M1.5 2.75a.25.25 0 01.25-.25h8.5a.25.25 0 01.25.25v5.5a.25.25 0 01-.25.25h-3.5a.75.75 0 00-.53.22L3.5 11.44V9.25a.75.75 0 00-.75-.75h-1a.25.25 0 01-.25-.25v-5.5zM1.75 1A1.75 1.75 0 000 2.75v5.5C0 9.216.784 10 1.75 10H2v1.543a1.457 1.457 0 002.487 1.03L7.061 10h3.189A1.75 1.75 0 0012 8.25v-5.5A1.75 1.75 0 0010.25 1h-8.5zM14.5 4.75a.25.25 0 00-.25-.25h-.5a.75.75 0 110-1.5h.5c.966 0 1.75.784 1.75 1.75v5.5A1.75 1.75 0 0114.25 12H14v1.543a1.457 1.457 0 01-2.487 1.03L9.22 12.28a.75.75 0 111.06-1.06l2.22 2.22v-2.19a.75.75 0 01.75-.75h1a.25.25 0 00.25-.25v-5.5z">
             </path>
             </svg></span><span class="ActionList-item-label">Collapsible, not expanded item</span><span class="ActionList-item-visual ActionList-item-visual--trailing"><svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false"
             class="ActionList-item-collapseIcon">
             <path fill-rule="evenodd" d="M12.78 6.22a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06 0L3.22 7.28a.75.75 0 011.06-1.06L8 9.94l3.72-3.72a.75.75 0 011.06 0z"></path>
             </svg></span>
             </button>
             <ul class="ActionList ActionList--subGroup" role="list">
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             </ul>
             </li>
             <li class="ActionList-sectionDivider">
             <h3 class="ActionList-sectionDivider-title">Section title</h3>
             </li>
             <li class="ActionList-item ActionList-item--hasSubItem">
             <button class="ActionList-content ActionList-content--hasActiveSubItem ActionList-content--visual16" aria-expanded="true"><span class="ActionList-item-visual ActionList-item-visual--leading"><svg class="octicon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
             <path fill-rule="evenodd"
             d="M1.5 2.75a.25.25 0 01.25-.25h8.5a.25.25 0 01.25.25v5.5a.25.25 0 01-.25.25h-3.5a.75.75 0 00-.53.22L3.5 11.44V9.25a.75.75 0 00-.75-.75h-1a.25.25 0 01-.25-.25v-5.5zM1.75 1A1.75 1.75 0 000 2.75v5.5C0 9.216.784 10 1.75 10H2v1.543a1.457 1.457 0 002.487 1.03L7.061 10h3.189A1.75 1.75 0 0012 8.25v-5.5A1.75 1.75 0 0010.25 1h-8.5zM14.5 4.75a.25.25 0 00-.25-.25h-.5a.75.75 0 110-1.5h.5c.966 0 1.75.784 1.75 1.75v5.5A1.75 1.75 0 0114.25 12H14v1.543a1.457 1.457 0 01-2.487 1.03L9.22 12.28a.75.75 0 111.06-1.06l2.22 2.22v-2.19a.75.75 0 01.75-.75h1a.25.25 0 00.25-.25v-5.5z">
             </path>
             </svg></span><span class="ActionList-item-label">Collapsible and expanded item</span><span class="ActionList-item-visual ActionList-item-visual--trailing"><svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false"
             class="ActionList-item-collapseIcon">
             <path fill-rule="evenodd" d="M12.78 6.22a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06 0L3.22 7.28a.75.75 0 011.06-1.06L8 9.94l3.72-3.72a.75.75 0 011.06 0z"></path>
             </svg></span>
             </button>
             <ul class="ActionList ActionList--subGroup" role="list">
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             </ul>
             </li>
             <li class="ActionList-sectionDivider">
             <h3 class="ActionList-sectionDivider-title">Section title</h3>
             </li>
             <li class="ActionList-item ActionList-item--hasSubItem">
             <button class="ActionList-content ActionList-content--hasActiveSubItem ActionList-content--visual24" aria-expanded="true"><span class="ActionList-item-visual ActionList-item-visual--leading"><svg class="octicon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
             <path fill-rule="evenodd"
             d="M1.75 1A1.75 1.75 0 000 2.75v9.5C0 13.216.784 14 1.75 14H3v1.543a1.457 1.457 0 002.487 1.03L8.061 14h6.189A1.75 1.75 0 0016 12.25v-9.5A1.75 1.75 0 0014.25 1H1.75zM1.5 2.75a.25.25 0 01.25-.25h12.5a.25.25 0 01.25.25v9.5a.25.25 0 01-.25.25h-6.5a.75.75 0 00-.53.22L4.5 15.44v-2.19a.75.75 0 00-.75-.75h-2a.25.25 0 01-.25-.25v-9.5z">
             </path>
             <path
             d="M22.5 8.75a.25.25 0 00-.25-.25h-3.5a.75.75 0 010-1.5h3.5c.966 0 1.75.784 1.75 1.75v9.5A1.75 1.75 0 0122.25 20H21v1.543a1.457 1.457 0 01-2.487 1.03L15.939 20H10.75A1.75 1.75 0 019 18.25v-1.465a.75.75 0 011.5 0v1.465c0 .138.112.25.25.25h5.5a.75.75 0 01.53.22l2.72 2.72v-2.19a.75.75 0 01.75-.75h2a.25.25 0 00.25-.25v-9.5z">
             </path>
             </svg></span><span class="ActionList-item-label">Collapsible and expanded item, wide visual</span><span class="ActionList-item-visual ActionList-item-visual--trailing"><svg width="16" height="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false"
             class="ActionList-item-collapseIcon">
             <path fill-rule="evenodd" d="M12.78 6.22a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06 0L3.22 7.28a.75.75 0 011.06-1.06L8 9.94l3.72-3.72a.75.75 0 011.06 0z"></path>
             </svg></span>
             </button>
             <ul class="ActionList ActionList--subGroup" role="list">
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             <li class="ActionList-item ActionList-item--subItem"><span class="ActionList-content"><span class="ActionList-item-label">Sub item</span></span></li>
             </ul>
             </li>
             """
             |> format_html()
  end

  test "Classes" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <.action_list_item
             classes={
               %{
                 action_list_item: "action_list_item-x",
                 content: "content-x",
                 label: "label-x",
                 description: "description-x",
                 description_container: "description_container-x",
                 leading_visual: "leading_visual-x",
                 trailing_visual: "trailing_visual-x",
                 sub_group: "sub_group-x"
               }
             }
             class="my-action-list-item"
           >
             <:link href="/url" class="my-link">
               Content
             </:link>
             <:description>
               A descriptive text
             </:description>
             <:leading_visual>
               Leading visual
             </:leading_visual>
             <:trailing_visual>
               Trailing visual
             </:trailing_visual>
             <:sub_group class="my-sub-group">
               <.action_list_item is_sub_item class="my-sub-item">
                 Sub item
               </.action_list_item>
             </:sub_group>
           </.action_list_item>
           """)
           |> format_html() ==
             """
             <li class="ActionList-item ActionList-item--hasSubItem action_list_item-x my-action-list-item" role="none">
             <a href="/url" aria-expanded="true" class="ActionList-content content-x my-link" role="menuitem">
             <span class="ActionList-item-visual ActionList-item-visual--leading leading_visual-x">
             Leading visual
             </span>
             <span class="ActionList-item-descriptionWrap ActionList-item-blockDescription description_container-x">
             <span class="ActionList-item-label label-x">Content</span>
             <span class="ActionList-item-description description-x">A descriptive text</span>
             </span>
             <span class="ActionList-item-visual ActionList-item-visual--trailing trailing_visual-x">Trailing visual</span>
             </a>
             <ul class="ActionList ActionList--subGroup sub_group-x my-sub-group" role="list">
             <li class="ActionList-item ActionList-item--subItem my-sub-item">
              <span class="ActionList-content">
              <span class="ActionList-item-label">Sub item</span>
              </span>
              </li>
             </ul>
             </li>
             """
             |> format_html()
  end
end
