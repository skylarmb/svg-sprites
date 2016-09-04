# SVG Sprite Sheet Demo

## Spin it up locally
1. `git clone git@github.com:skylarmb/svg-sprites.git`
2. `bundle install`
3. `spring rails server`

## TL;DR
Render a hidden SVG in the body of your page that contains all the icons or graphics needed for the page.  This is the "sprite sheet". Use `<svg>` and `<use>` tags to reference the symbols defined in the sprite sheet instead of using icon fonts or `img` tags.

## How To

#### The CSS
There is a little but of CSS in `app/assets/stylesheets/styles.scss`. Nothing special.

#### The SVG Sprite Sheet
Check out `app/views/svg/_icons.svg`. Each icon consists of a `<symbol>` with an `id`, a `<title>` (optional?), and one or more `<path>`s. A tool like [icomoon](https://icomoon.io/app/) makes generating / managing these symbols easy.

    <symbol id="facebook" viewBox="0 0 32 32">
      <title>facebook</title>
      <path class="path1" d="..."></path>
    </symbol>

#### The HTML (Haml)
In `app/views/svg/index.html.haml` we first render the SVG file just like we would a partial (neato huh?)

    = render partial: 'icons.svg'

Then, anywhere else on the page we can reference symbols using their `id`

    %svg.icon
      %use{'xlink:href' => '#facebook'}
    %h3 Facebook

Result:

![](http://i.imgur.com/rTFskwM.png)

#### A view helper
A handy view helper could be made, like in `app/helpers/svg_helper.rb`

    def svg_icon(id)
      haml_tag :svg, class: 'icon' do
        haml_tag :use, 'xlink:href' => "##{id}"
      end
    end

Usage:

    - svg_icon('facebook')
    %h3 Reddit

Result: Same as above! (note: `haml_tag` outputs directly to the Haml template instead of returning a string, so use `-` in the Haml instead of `=`)

## Advantages

1. The sprite sheet with every icon needed on the page is part of the HTML document. This reduces the number of network requests your browser makes as well as ensures that as soon as the browser renders the HTML of the page, all icons will render instantly instead of waiting for an icon font or image to load.
2. The sprite sheet is an SVG, meaning it can be versioned in git like any other piece of code rather than a binary .woff or .ttf file.
3. Your SVG icons will look as crisp as browserly possible no matter the display resolution, whether it be retina or potato. SVGs are vectors, meaning they can be scaled infinitely without any loss in "resolution". In comparison, icon fonts are anti-aliased by the browser if used at large or sub-pixel sizes (causing fuzzy edges), and images straight up become pixelated.
4. You can style SVGs with CSS. Yes, you can style icon fonts (size and color), but with SVGs you can also style specific parts of a multi-part icon. Need your company icon with an orange logo and white text in one place, but orange logo and black text somewhere else? No problem. Just use the same SVG with different CSS applied to it.
5. You get rid of a bunch of the headaches of icon fonts like positioning pseudo elements, CORS security, the surprising lack of `@font-face` support is some browsers.
6. SVGs are more accessible. They can have `<title>`s and `<desc>`s (descriptions) as well as any `aria-label`s you like.

## Disadvantages
1. Internet Explorer 8 and lower don't support SVG, which could be a dealbreaker for some.

