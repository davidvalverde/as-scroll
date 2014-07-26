import mx.utils.Delegate;
import mx.transitions.Tween;
import mx.transitions.easing.Regular;

/**
 * <p>La clase <pre>Scroll</pre> permite 'scrollear' un <pre>MovieClip</pre>. La clase es bastante 
 * parametrizable pudiendo integrarla en cualquier desarrollo. Tiene varios parámetros que 
 * permiten modificar el scroll a gusto del usuario.</p>
 * 
 * <p>Uso:</p>
 * 
 * <code>var myscroll: Scroll = new Scroll();</code>
 * 
 * <p>aunque también se puede pasar un parámetro al constructor de la clase con la línea de tiempo
 * en la que se va a crear el Scroll:</p>
 * 
 * <code>var myscroll: Scroll = new Scroll(this);</code>
 * 
 * <p>De este modo sólo hemos creado el scroll pero no aparece nada, ahora hay que inicializar sus
 * propiedades (las que queramos modificar sus opciones por defecto): </p>
 * 
 * <ul>
 * <li><pre>_x</pre>: Coordenada x del scroll. Por defecto 0.</li>
 * <li><pre>_y</pre>: Coordenada y del scroll. Por defecto 0.</li>
 * <li><pre>_width</pre>: Ancho del scroll. Por defecto 0.</li>
 * <li><pre>_height</pre>: Altura del scroll. Por defecto 0.</li>
 * <li><pre>_arrows</pre>: Boolean. Indica si se pondrán las flechas de desplazamiento del scroll,
 * ya sean por defecto o creadas por el usuario. Por defecto true</li>
 * <li><pre>_bar</pre>: Boolean. Indica si se pondrán las barras del scroll, ya sean por
 * defecto o creadas por el usuario. Por defecto true</li>
 * <li><pre>_orientation</pre>: Indica la orientación del scroll; es decir, si va a ser vertical,
 * horizontal o ambos. Por defecto tiene el valor BOTH (ambos). Hay que puntualizar que si las
 * dimensiones del scroll son mayores que las del contenido no aparecerá el scroll.</li>
 * <li><pre>_barwidth</pre>: Ancho de la barra de scroll y flechas creadas por defecto. El valor 
 * por defecto es 5 píxeles.</li>
 * <li><pre>_increase</pre>: Desplazamiento en píxeles del contenido al mover el scroll. Por
 * defecto 5.</li>
 * <li><pre>_speed</pre>: Velocidad de desplazamiento del scroll. El valor estará comprendido entre
 * 1 y 20. A mayor número, mayor velocidad de desplazamiento. Por defecto 10</li>
 * <li><pre>_arrowcolor</pre>: Color de las flechas de desplazamiento del scroll creadas por
 * defecto. Si no se modifica, su valor es 0x000000 (negro).</li>
 * <li><pre>_barcolor</pre>: Color de las barras de desplazamiento del scroll creadas por defecto.
 * Si no se modifica, su valor es 0x333333 (gris oscuro).</li>
 * <li><pre>_timeline</pre>: Línea de tiempo donde se va a crear el scroll. Como se ha visto antes
 * se puede pasar como parámetro al constructor o mediante esta propiedad. Por defecto _root.</li>
 * <li><pre>_content</pre>: MovieClip que se quiere 'scrollear'.</li>
 * <li><pre>_upArrow</pre>: MovieClip creado por el usuario para la flecha hacia arriba.</li>
 * <li><pre>_downArrow</pre>: MovieClip creado por el usuario para la flecha hacia abajo.</li>
 * <li><pre>_leftArrow</pre>: MovieClip creado por el usuario para la flecha hacia la 
 * izquierda.</li>
 * <li><pre>_rightArrow</pre>: MovieClip creado por el usuario para la flecha hacia la 
 * derecha.</li>
 * <li><pre>_verticalBar</pre>: MovieClip creado por el usuario para la barra de desplazamiento 
 * vertical.</li>
 * <li><pre>_horizontalBar</pre>: MovieClip creado por el usuario para la barra de desplazamiento 
 * horizontal.</li>
 * </ul>
 * 
 * <p>Bien, hemos creado el scroll y le hemos dado algunas propiedades, pero... sigo sin poder ver
 * el scroll. Para mostrarlo en pantalla sólo queda un último paso:</p>
 * 
 * <code>myscroll.generateScroll();</code>
 * 
 * @author dmvalverde (http://www.davidvalverde.com/)
 * 
 * @version 1.1.7
 */
class com.davidvalverde.ui.Scroll {
	
	/**
	 * Orientación del scroll: vertical, horizontal o ambos.
	 */
	public static var BOTH: Number = 0;
	public static var VERTICAL: Number = 1;
	public static var HORIZONTAL: Number = 2;
	
	/**
	 * Velocidad de desplazamiento del scroll.
	 */
	public static var MIN_SPEED: Number = 1;
	private static var DFT_SPEED: Number = 10;
	public static var MAX_SPEED: Number = 20;
	
	/**
	 * Desplazamiento del scroll (en píxeles).
	 */
	private static var DFT_INCREASE: Number = 5;
	
	/**
	 * Ancho de <pre>upArrow_mc</pre>, <pre>downArrow_mc</pre> y <pre>scrollBar_mc</pre> en el caso
	 * de que no se les asigne ninguno y las propiedades <pre>_arrow</pre> y <pre>_scrollbar</pre>
	 * sean true.
	 */
	private static var BAR_LEN: Number = 5;
	
	/**
	 * Colores.
	 */
	private static var ARROW_COLOR: Number = 0x000000;
	private static var BAR_COLOR: Number = 0x333333;
	
	/**
	 * Posición X del Scroll.
	 */
	private var m_x: Number;
	
	/**
	 * Posición Y del Scroll.
	 */
	private var m_y: Number;
	
	/**
	 * Ancho del Scroll.
	 */
	private var m_width: Number;
	
	/**
	 * Altura del Scroll.
	 */
	private var m_height: Number;
	
	/**
	 * Indica si se utilizarán flechas para el movimiento del scroll.
	 */
	private var m_arrows: Boolean;
	
	/**
	 * Indica si habrá una barra de scroll.
	 */
	private var m_bar: Boolean;
	
	/**
	 * Indica la orientación del scroll.
	 */
	private var m_orientation: Number;
	
	/**
	 * Aumento del scroll cuando se pulsan upArrow o downArrow. Cantidad de pixeles que se desplaza
	 * el MC contenido.
	 */
	private var m_increase: Number;
	
	/**
	 * Ancho de la barra de scroll por defecto.
	 */
	private var m_barWidth: Number;
	
	/**
	 * Velocidad que tendrá el scroll cuando se dejen pulsados los botones upArrow o downArrow. Se 
	 * mide
	 */
	private var m_speed: Number;
	
	/**
	 * Indica si el scroll tiene easing o no.	 */
	private var m_easing: Boolean;
	
	/**
	 * Nueva posición X de m_content_mc cuando se utiliza easing.
	 */
	private var m_newXPosition: Number;
	
	/**
	 * Vieja posición X de m_content_mc cuando se utiliza easing.
	 */
	private var m_oldXPosition: Number;
	
	/**
	 * Tween utilizado en el easing del scroll horizontal.
	 */
	private var m_tweenX: Tween;
	
	/**
	 * Nueva posición Y de m_content_mc cuando se utiliza easing.	 */
	private var m_newYPosition: Number;
	
	/**
	 * Vieja posición Y de m_content_mc cuando se utiliza easing.	 */
	private var m_oldYPosition: Number;
	
	/**
	 * Tween utilizado en el easing del scroll vertical.	 */
	private var m_tweenY: Tween;
	
	/**
	 * Indica el color de las flechas por defecto del scroll.
	 */
	private var m_arrowColor: Number;
	
	/**
	 * Indica el color de la barra de scroll por defecto.
	 */
	private var m_barColor: Number;
	
	/**
	 * Id del intervalo. Para utilizar con setInterval() y clearInterval().
	 */
	private var m_idInterval: Number;
	
	/**
	 * Ruta donde se va a colocar el Scroll.
	 */
	private var m_timeline_mc: MovieClip;
	
	/**
	 * MovieClip con el contenido que se va a 'scrollear'.
	 */
	private var m_content_mc: MovieClip;
	
	/**
	 * MovieClip máscara que se genera dinámicamente.
	 */
	private var m_mask_mc: MovieClip;
	
	/**
	 * Flecha arriba del Scroll.
	 */
	private var m_upArrow_mc: MovieClip;
	
	/**
	 * Flecha abajo del Scroll.
	 */
	private var m_downArrow_mc: MovieClip;
	
	/**
	 * Flecha izquierda del Scroll.
	 */
	private var m_leftArrow_mc: MovieClip;
	
	/**
	 * Flecha derecha del Scroll.
	 */
	private var m_rightArrow_mc: MovieClip;
	
	/**
	 * Barra vertical del Scroll.
	 */
	private var m_verticalBar_mc: MovieClip;
	
	/**
	 * Guía de la barra vertical del Scroll.
	 */
	private var m_verticalBarGuide_mc: MovieClip;
	
	/**
	 * Barra horizontal del Scroll.
	 */
	private var m_horizontalBar_mc: MovieClip;
	
	/**
	 * Guía de la barra horizontal del Scroll.
	 */
	private var m_horizontalBarGuide_mc: MovieClip;
	
	///// PUBLIC //////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Scroll()<br>
	 * Scroll(MovieClip)<br>
	 * <p>Constructor de la clase <pre>Scroll</pre>. Se encarga de inicializar las variables.</p>
	 * 
	 * @param timeline Ruta o MovieClip donde se va a poner el Scroll.
	 */
	public function Scroll(timeline: MovieClip) {
		
		this.removeAll();
		
		if (timeline != undefined) {
			m_timeline_mc = timeline;
		} else {
			m_timeline_mc = _root;
		}
		
		m_x = 0;
		m_y = 0;
		m_width = 0;
		m_height = 0;
		m_arrows = true;
		m_bar = true;
		m_orientation = BOTH;
		m_barWidth = BAR_LEN;
		m_increase = DFT_INCREASE;
		m_speed = DFT_SPEED;
		m_easing = false;
		m_arrowColor = ARROW_COLOR;
		m_barColor = BAR_COLOR;
		m_idInterval = 0;
		
	}
	
	/**
	 * generateScroll()<br>
	 * <p>Crea el Scroll con los parámetros que deben ser asignados con anterioridad.</p>
	 */
	public function generateScroll(): Void {
		
		m_mask_mc.removeMovieClip();
		this.initInterface();
		
	}
	
	
	///// GETTERS y SETTERS ///////////////////////////////////////////////////////////////////////
	
	public function get _x(): Number {
		return m_x;
	}
	
	public function set _x(x: Number): Void {
		m_x = x;
	}
	
	public function get _y(): Number {
		return m_y;
	}
	
	public function set _y(y: Number): Void {
		m_y = y;
	}
	
	public function get _width(): Number {
		return m_width;
	}
	
	public function set _width(width: Number): Void {
		m_width = width;
	}
	
	public function get _height(): Number {
		return m_height;
	}
	
	public function set _height(height: Number): Void {
		m_height = height;
	}
	
	public function get _arrows(): Boolean {
		return m_arrows;
	}
	
	public function set _arrows(arrows: Boolean): Void {
		m_arrows = arrows;
	}
	
	public function get _bar(): Boolean {
		return m_bar;
	}
	
	public function set _bar(bar: Boolean): Void {
		m_bar = bar;
	}
	
	public function get _orientation(): Number {
		return m_orientation;
	}
	
	public function set _orientation(orientation: Number): Void {
		if ((orientation != BOTH) && (orientation != VERTICAL) && (orientation != HORIZONTAL)) {
			m_orientation = BOTH;
		} else {
			m_orientation = orientation;
		}
	}
	
	public function get _barwidth(): Number {
		return m_barWidth;
	}
	
	public function set _barwidth(barwidth: Number): Void {
		m_barWidth = barwidth;
	}
	
	public function get _increase(): Number {
		return m_increase;
	}
	
	public function set _increase(increase: Number): Void {
		m_increase = increase;
	}
	
	public function get _speed(): Number {
		return m_speed;
	}
	
	public function set _speed(speed: Number): Void {
		if (speed < MIN_SPEED) {
			m_speed = MIN_SPEED;
		} else if (speed > MAX_SPEED) {
			m_speed = MAX_SPEED;
		} else {
			m_speed = speed;
		}
	}
	
	public function get _easing(): Boolean {
		return m_easing;
	}
	
	public function set _easing(easing: Boolean): Void {
		m_easing = easing;
	}
	
	public function get _arrowcolor(): Number {
		return m_arrowColor;
	}
	
	public function set _arrowcolor(arrowcolor: Number): Void {
		m_arrowColor = arrowcolor;
	}
	
	public function get _barcolor(): Number {
		return m_barColor;
	}
	
	public function set _barcolor(barcolor: Number): Void {
		m_barColor = barcolor;
	}
	
	public function get _timeline(): MovieClip {
		return m_timeline_mc;
	}
	
	public function set _timeline(timeline: MovieClip): Void {
		m_timeline_mc = timeline;
	}
	
	public function get _content(): MovieClip {
		return m_content_mc;
	}
	
	public function set _content(content: MovieClip): Void {
		m_content_mc = content;
	}
	
	public function get _upArrow(): MovieClip {
		return m_upArrow_mc;
	}
	
	public function set _upArrow(upArrow: MovieClip): Void {
		m_upArrow_mc = upArrow;
	}
	
	public function get _downArrow(): MovieClip {
		return m_downArrow_mc;
	}
	
	public function set _downArrow(downArrow: MovieClip): Void {
		m_downArrow_mc = downArrow;
	}
	
	public function get _leftArrow(): MovieClip {
		return m_leftArrow_mc;
	}
	
	public function set _leftArrow(leftArrow: MovieClip): Void {
		m_leftArrow_mc = leftArrow;
	}
	
	public function get _rightArrow(): MovieClip {
		return m_rightArrow_mc;
	}
	
	public function set _rightArrow(rightArrow: MovieClip): Void {
		m_rightArrow_mc = rightArrow;
	}
	
	public function get _verticalBar(): MovieClip {
		return m_verticalBar_mc;
	}
	
	public function set _verticalBar(verticalBar: MovieClip): Void {
		m_verticalBar_mc = verticalBar;
	}
	
	public function get _horizontalBar(): MovieClip {
		return m_horizontalBar_mc;
	}
	
	public function set _horizontalBar(horizontalBar: MovieClip): Void {
		m_horizontalBar_mc = horizontalBar;
	}
	
	
	///// PRIVATE /////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * removeAll()<br>
	 * <p>Elimina todas las referencias a los MCs.</p>
	 */
	private function removeAll(): Void {
		
		m_timeline_mc = null;
		m_mask_mc = null;
		m_upArrow_mc = null;
		m_downArrow_mc = null;
		m_leftArrow_mc = null;
		m_rightArrow_mc = null;
		m_verticalBar_mc = null;
		m_verticalBarGuide_mc = null;
		m_horizontalBar_mc = null;
		m_horizontalBarGuide_mc = null;
		
	}
	
	/**
	 * initInterface()<br>
	 * <p>Crea la interface del Scroll sólo si es necesario 'scrollear' el contenido.</p>
	 */
	private function initInterface(): Void {
		
		// Mascara
		this.createMask();
		
		// Comprobamos si es necesario el scroll vertical
		if (m_content_mc._height > m_height) {
			// Flechas de desplazamiento
			this.createVerticalArrows();
			// Barra del scroll
			this.createVerticalBar();
		} else {
			m_upArrow_mc.removeMovieClip();
			m_downArrow_mc.removeMovieClip();
			m_verticalBar_mc.removeMovieClip();
			m_verticalBarGuide_mc.removeMovieClip();
			m_upArrow_mc = null;
			m_downArrow_mc = null;
			m_verticalBar_mc = null;
			m_verticalBarGuide_mc = null;
		}
		
		// Comprobamos si es necesario el scroll horizontal
		if (m_content_mc._width > m_width) {
			// Flechas de desplazamiento
			this.createHorizontalArrows();
			// Barra del scroll
			this.createHorizontalBar();
		} else {
			m_leftArrow_mc.removeMovieClip();
			m_rightArrow_mc.removeMovieClip();
			m_horizontalBar_mc.removeMovieClip();
			m_horizontalBarGuide_mc.removeMovieClip();
			m_leftArrow_mc = null;
			m_rightArrow_mc = null;
			m_horizontalBar_mc = null;
			m_horizontalBarGuide_mc = null;
		}
		
	}
	
	/**
	 * createMask()<br>
	 * <p>Crea la máscara del scroll. Deben haberse pasado la linea de tiempo donde se va a crear
	 * el scroll así como el contenido a scrollear. Además tambien deberían haberse indicado las
	 * coordenadas y dimensiones del scroll.</p>
	 */
	private function createMask(): Void {
		
		m_mask_mc = m_timeline_mc.createEmptyMovieClip("mask", m_timeline_mc.getNextHighestDepth());
		m_mask_mc._x = m_x;
		m_mask_mc._y = m_y;
		m_mask_mc.beginFill(0xff0000);
		m_mask_mc.moveTo(0,0);
		m_mask_mc.lineTo(m_width,0);
		m_mask_mc.lineTo(m_width,m_height);
		m_mask_mc.lineTo(0,m_height);
		m_mask_mc.lineTo(0,0);
		m_mask_mc.endFill();
		m_content_mc.setMask(m_mask_mc);
		
	}
	
	/**
	 * createVerticalArrows()<br>
	 * <p>Crea las flechas de desplazamiento del scroll. Si la propiedad <pre>_arrows</pre> tiene 
	 * el valor false no habrá flechas. Mediante los MCs <pre>m_upArrow_mc</pre> y
	 * <pre>m_downArrow_mc</pre>, el usuario puede asignar sus propias flechas de desplazamiento;
	 * sin embargo, si alguna de ellas no está asignada se crean unas por defecto. Por último se le
	 * asignan los eventos a cada una de las flechas.</p>
	 */
	private function createVerticalArrows(): Void {
		
		// Comprobamos la propiedad _arrows
		if (m_arrows == false) {
			m_upArrow_mc = null;
			m_downArrow_mc = null;
		} else {
			// Si no les está asignado algún MC se crean unos por defecto
			if ((m_upArrow_mc == null) || (m_downArrow_mc == null)) {
				m_upArrow_mc = null;
				m_downArrow_mc = null;
				this.createDefaultVerticalArrows();
			}
			// Asigna eventos
			m_upArrow_mc.onPress = Delegate.create(this, __upArrowPressed);
			m_upArrow_mc.onRelease = Delegate.create(this, __upArrowReleased);
			m_upArrow_mc.onReleaseOutside = Delegate.create(this, __upArrowReleased);
			m_downArrow_mc.onPress = Delegate.create(this, __downArrowPressed);
			m_downArrow_mc.onRelease = Delegate.create(this, __downArrowReleased);
			m_downArrow_mc.onReleaseOutside = Delegate.create(this, __downArrowReleased);
		}
		
	}
	
	/**
	 * createDefaultVerticalArrows()<br>
	 * <p>Crea las flechas de desplazamiento por defecto.</p>
	 */
	private function createDefaultVerticalArrows(): Void {
		
		// Flecha arriba
		m_upArrow_mc = m_timeline_mc.createEmptyMovieClip("upArrow", m_timeline_mc.getNextHighestDepth());
		m_upArrow_mc._x = m_x + m_width;
		m_upArrow_mc._y = m_y;
		this.createDefaultArrows(m_upArrow_mc);
		
		// Flecha abajo
		m_downArrow_mc = m_timeline_mc.createEmptyMovieClip("downArrow", m_timeline_mc.getNextHighestDepth());
		m_downArrow_mc._x = m_x + m_width;
		m_downArrow_mc._y = m_y + m_height - m_barWidth;
		this.createDefaultArrows(m_downArrow_mc);
		
	}
	
	/**
	 * createHorizontalArrows()<br>
	 * <p>Crea las flechas de desplazamiento del scroll. Si la propiedad <pre>_arrows</pre> tiene 
	 * el valor false no habrá flechas. Mediante los MCs <pre>m_leftArrow_mc</pre> y
	 * <pre>m_rightArrow_mc</pre>, el usuario puede asignar sus propias flechas de desplazamiento;
	 * sin embargo, si alguna de ellas no está asignada se crean unas por defecto. Por último se le
	 * asignan los eventos a cada una de las flechas.</p>
	 */
	private function createHorizontalArrows(): Void {
		
		// Comprobamos la propiedad _arrows
		if (m_arrows == false) {
			m_leftArrow_mc = null;
			m_rightArrow_mc = null;
		} else {
			// Si no les está asignado algún MC se crean unos por defecto
			if ((m_leftArrow_mc == null) || (m_rightArrow_mc == null)) {
				m_leftArrow_mc = null;
				m_rightArrow_mc = null;
				this.createDefaultHorizontalArrows();
			}
			// Asigna eventos
			m_leftArrow_mc.onPress = Delegate.create(this, __leftArrowPressed);
			m_leftArrow_mc.onRelease = Delegate.create(this, __leftArrowReleased);
			m_leftArrow_mc.onReleaseOutside = Delegate.create(this, __leftArrowReleased);
			m_rightArrow_mc.onPress = Delegate.create(this, __rightArrowPressed);
			m_rightArrow_mc.onRelease = Delegate.create(this, __rightArrowReleased);
			m_rightArrow_mc.onReleaseOutside = Delegate.create(this, __rightArrowReleased);
		}
		
	}
	
	/**
	 * createDefaultHorizontalArrows()<br>
	 * <p>Crea las flechas de desplazamiento por defecto.</p>
	 */
	private function createDefaultHorizontalArrows(): Void {
		
		// Flecha izquierda
		m_leftArrow_mc = m_timeline_mc.createEmptyMovieClip("leftArrow", m_timeline_mc.getNextHighestDepth());
		m_leftArrow_mc._x = m_x;
		m_leftArrow_mc._y = m_y + m_height;
		this.createDefaultArrows(m_leftArrow_mc);
		
		// Flecha derecha
		m_rightArrow_mc = m_timeline_mc.createEmptyMovieClip("rightArrow", m_timeline_mc.getNextHighestDepth());
		m_rightArrow_mc._x = m_x + m_width - m_barWidth;
		m_rightArrow_mc._y = m_y + m_height;
		this.createDefaultArrows(m_rightArrow_mc);
		
	}
	
	/**
	 * createDefaultArrows(MovieClip)<br>
	 * <p>Crea las flechas de desplazamiento por defecto que tienen en común el mismo código.</p>
	 * 
	 * @param arrow_mc MovieClip con la flecha a dibujar (v. atributos de la clase).	 */
	private function createDefaultArrows(arrow_mc: MovieClip): Void {
		
		var wide: Number = Math.floor(m_barWidth/10);
		
		// Flecha
		arrow_mc.beginFill(m_arrowColor);
		arrow_mc.moveTo(0,0);
		arrow_mc.lineTo(m_barWidth,0);
		arrow_mc.lineTo(m_barWidth,m_barWidth);
		arrow_mc.lineTo(0,m_barWidth);
		arrow_mc.lineTo(0,0);
		arrow_mc.endFill();
		
		// Reflejo de la flecha
		arrow_mc.beginFill(0xffffff,20);
		arrow_mc.moveTo(0,3*m_barWidth/4);
		arrow_mc.curveTo(m_barWidth/4,m_barWidth/2,m_barWidth/2,m_barWidth/2);
		arrow_mc.curveTo(3*m_barWidth/4,m_barWidth/2,m_barWidth,m_barWidth/4);
		arrow_mc.lineTo(m_barWidth,0);
		arrow_mc.lineTo(0,0);
		arrow_mc.lineTo(0,3*m_barWidth/4);
		arrow_mc.endFill();
		
		// Relieve de la flecha
		arrow_mc.beginFill(0xffffff,10);
		arrow_mc.moveTo(m_barWidth,0);
		arrow_mc.lineTo(m_barWidth,m_barWidth);
		arrow_mc.lineTo(0,m_barWidth);
		arrow_mc.lineTo(wide,m_barWidth-wide);
		arrow_mc.lineTo(m_barWidth-wide,m_barWidth-wide);
		arrow_mc.lineTo(m_barWidth-wide,wide);
		arrow_mc.lineTo(m_barWidth,0);
		arrow_mc.endFill();
		
		arrow_mc.beginFill(0x000000,10);
		arrow_mc.moveTo(0,0);
		arrow_mc.lineTo(m_barWidth,0);
		arrow_mc.lineTo(m_barWidth-wide,wide);
		arrow_mc.lineTo(wide,wide);
		arrow_mc.lineTo(wide,m_barWidth-wide);
		arrow_mc.lineTo(0,m_barWidth);
		arrow_mc.lineTo(0,0);
		arrow_mc.endFill();
		
	}
	
	/**
	 * createVerticalBar()<br>
	 * <p>Crea la barra del scroll. Si la propiedad <pre>_scrollbar</pre> tiene el valor false no 
	 * habrá barra. Mediante el MC <pre>m_scrollVBar_mc</pre> el usuario puede asignar su propia 
	 * barra de scroll; sin embargo, si no tiene una barra asignada se crea una por defecto. Por 
	 * último se le asignan los eventos a la barra.</p>
	 */
	private function createVerticalBar(): Void {
		
		// Comprobamos la propiedad _bar
		if (m_bar == false) {
			m_verticalBar_mc = null;
		} else {
			// Si no tiene asignado ningún MC se crea uno por defecto
			if (m_verticalBar_mc == null) {
				this.createDefaultVerticalBar();
			}
			// Asigna eventos
			m_verticalBar_mc.onPress = Delegate.create(this, __verticalBarPressed);
			m_verticalBar_mc.onRelease = Delegate.create(this, __verticalBarReleased);
			m_verticalBar_mc.onReleaseOutside = Delegate.create(this, __verticalBarReleased);
			// Longitud de la barra
			m_verticalBar_mc._yscale = Math.floor(100*m_height/m_content_mc._height);
		}
		
	}
	
	/**
	 * createDefaultVerticalBar()<br>
	 * <p>Crea la barra de scroll por defecto.</p>
	 */
	private function createDefaultVerticalBar(): Void {
		
		var wide: Number = Math.floor(m_barWidth/10);
		
		// Guia de la barra de scroll
		m_verticalBarGuide_mc = m_timeline_mc.createEmptyMovieClip("verticalBarGuide", m_timeline_mc.getNextHighestDepth());
		m_verticalBarGuide_mc._x = m_x + m_width;
		m_verticalBarGuide_mc._y = m_y + m_barWidth;
		m_verticalBarGuide_mc.beginFill(m_barColor);
		m_verticalBarGuide_mc.moveTo(0,0);
		m_verticalBarGuide_mc.lineTo(m_barWidth,0);
		m_verticalBarGuide_mc.lineTo(m_barWidth,m_height-2*m_barWidth);
		m_verticalBarGuide_mc.lineTo(0,m_height-2*m_barWidth);
		m_verticalBarGuide_mc.lineTo(0,0);
		m_verticalBarGuide_mc.endFill();
		m_verticalBarGuide_mc._alpha = 20;
		
		// Barra de scroll
		m_verticalBar_mc = m_timeline_mc.createEmptyMovieClip("verticalBar", m_timeline_mc.getNextHighestDepth());
		m_verticalBar_mc._x = m_x + m_width;
		m_verticalBar_mc._y = m_y + m_barWidth;
		m_verticalBar_mc.beginFill(m_barColor);
		m_verticalBar_mc.moveTo(0,0);
		m_verticalBar_mc.lineTo(m_barWidth,0);
		m_verticalBar_mc.lineTo(m_barWidth,m_height-2*m_barWidth);
		m_verticalBar_mc.lineTo(0,m_height-2*m_barWidth);
		m_verticalBar_mc.lineTo(0,0);
		m_verticalBar_mc.endFill();
		
		m_verticalBar_mc.beginFill(0xffffff,20);
		m_verticalBar_mc.moveTo(0,0);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width,0);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width,m_verticalBar_mc._height/2);
		m_verticalBar_mc.lineTo(0,m_verticalBar_mc._height/2);
		m_verticalBar_mc.lineTo(0,0);
		m_verticalBar_mc.endFill();
		
		m_verticalBar_mc.beginFill(0xffffff,10);
		m_verticalBar_mc.moveTo(m_verticalBar_mc._width,0);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width,m_verticalBar_mc._height);
		m_verticalBar_mc.lineTo(0,m_verticalBar_mc._height);
		m_verticalBar_mc.lineTo(wide,m_verticalBar_mc._height-wide);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width-wide,m_verticalBar_mc._height-wide);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width-wide,wide);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width,0);
		m_verticalBar_mc.endFill();
		
		m_verticalBar_mc.beginFill(0x000000,10);
		m_verticalBar_mc.moveTo(0,0);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width,0);
		m_verticalBar_mc.lineTo(m_verticalBar_mc._width-wide,wide);
		m_verticalBar_mc.lineTo(wide,wide);
		m_verticalBar_mc.lineTo(wide,m_verticalBar_mc._height-wide);
		m_verticalBar_mc.lineTo(0,m_verticalBar_mc._height);
		m_verticalBar_mc.lineTo(0,0);
		m_verticalBar_mc.endFill();
		
	}
	
	/**
	 * createHorizontalBar()<br>
	 * <p>Crea la barra del scroll. Si la propiedad <pre>_bar</pre> tiene el valor false no 
	 * habrá barra. Mediante el MC <pre>m_horizontalBar_mc</pre> el usuario puede asignar su propia 
	 * barra de scroll; sin embargo, si no tiene una barra asignada se crea una por defecto. Por 
	 * último se le asignan los eventos a la barra.</p>
	 */
	private function createHorizontalBar(): Void {
		
		// Comprobamos la propiedad _bar
		if (m_bar == false) {
			m_horizontalBar_mc = null;
		} else {
			// Si no tiene asignado ningún MC se crea uno por defecto
			if (m_horizontalBar_mc == null) {
				this.createDefaultHorizontalBar();
			}
			// Asigna eventos
			m_horizontalBar_mc.onPress = Delegate.create(this, __horizontalBarPressed);
			m_horizontalBar_mc.onRelease = Delegate.create(this, __horizontalBarReleased);
			m_horizontalBar_mc.onReleaseOutside = Delegate.create(this, __horizontalBarReleased);
			// Longitud de la barra
			m_horizontalBar_mc._xscale = Math.floor(100*m_width/m_content_mc._width);
		}
		
	}
	
	/**
	 * createDefaultHorizontalBar()<br>
	 * <p>Crea la barra de scroll por defecto.</p>
	 */
	private function createDefaultHorizontalBar(): Void {
		
		var wide: Number = Math.floor(m_barWidth/10);
		
		// Guia de la barra de scroll
		m_horizontalBarGuide_mc = m_timeline_mc.createEmptyMovieClip("horizontalBarGuide", m_timeline_mc.getNextHighestDepth());
		m_horizontalBarGuide_mc._x = m_x + m_barWidth;
		m_horizontalBarGuide_mc._y = m_y + m_height;
		m_horizontalBarGuide_mc.beginFill(m_barColor);
		m_horizontalBarGuide_mc.moveTo(0,0);
		m_horizontalBarGuide_mc.lineTo(m_width-2*m_barWidth,0);
		m_horizontalBarGuide_mc.lineTo(m_width-2*m_barWidth,m_barWidth);
		m_horizontalBarGuide_mc.lineTo(0,m_barWidth);
		m_horizontalBarGuide_mc.lineTo(0,0);
		m_horizontalBarGuide_mc.endFill();
		m_horizontalBarGuide_mc._alpha = 20;
		
		// Barra de scroll
		m_horizontalBar_mc = m_timeline_mc.createEmptyMovieClip("horizontalBar", m_timeline_mc.getNextHighestDepth());
		m_horizontalBar_mc._x = m_x + m_barWidth;
		m_horizontalBar_mc._y = m_y + m_height;
		m_horizontalBar_mc.beginFill(m_barColor);
		m_horizontalBar_mc.moveTo(0,0);
		m_horizontalBar_mc.lineTo(m_width-2*m_barWidth,0);
		m_horizontalBar_mc.lineTo(m_width-2*m_barWidth,m_barWidth);
		m_horizontalBar_mc.lineTo(0,m_barWidth);
		m_horizontalBar_mc.lineTo(0,0);
		m_horizontalBar_mc.endFill();
		
		m_horizontalBar_mc.beginFill(0xffffff,20);
		m_horizontalBar_mc.moveTo(0,0);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width,0);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width,m_horizontalBar_mc._height/2);
		m_horizontalBar_mc.lineTo(0,m_horizontalBar_mc._height/2);
		m_horizontalBar_mc.lineTo(0,0);
		m_horizontalBar_mc.endFill();
		
		m_horizontalBar_mc.beginFill(0xffffff,10);
		m_horizontalBar_mc.moveTo(m_horizontalBar_mc._width,0);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width,m_horizontalBar_mc._height);
		m_horizontalBar_mc.lineTo(0,m_horizontalBar_mc._height);
		m_horizontalBar_mc.lineTo(wide,m_horizontalBar_mc._height-wide);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width-wide,m_horizontalBar_mc._height-wide);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width-wide,wide);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width,0);
		m_horizontalBar_mc.endFill();
		
		m_horizontalBar_mc.beginFill(0x000000,10);
		m_horizontalBar_mc.moveTo(0,0);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width,0);
		m_horizontalBar_mc.lineTo(m_horizontalBar_mc._width-wide,wide);
		m_horizontalBar_mc.lineTo(wide,wide);
		m_horizontalBar_mc.lineTo(wide,m_horizontalBar_mc._height-wide);
		m_horizontalBar_mc.lineTo(0,m_horizontalBar_mc._height);
		m_horizontalBar_mc.lineTo(0,0);
		m_horizontalBar_mc.endFill();
		
	}
	
	
	/**
	 * movev(delta)<br>
	 * <p>Desplaza el contenido del scroll una cantidad <pre>delta</pre>.</p>
	 * 
	 * @param delta Cantidad de píxeles que se va a desplazar el contenido del scroll. Dependiendo
	 * del signo que tenga se moverá hacia arriba o hacia abajo.
	 */
	private function movev(delta: Number): Void {
		
		//m_oldYPosition = m_content_mc._y;
		
		// Mover el contenido
		if (delta > 0) { // upArrow
			if ((m_content_mc._y + delta) > m_mask_mc._y) {
				//m_content_mc._y = m_mask_mc._y;
				m_newYPosition = m_mask_mc._y;
			} else {
				//m_content_mc._y += delta;
				m_newYPosition = m_content_mc._y + delta;
			}
		} else { // downArrow
			if ((m_content_mc._y + m_content_mc._height + delta) < (m_mask_mc._y + m_mask_mc._height)) {
				//m_content_mc._y = m_mask_mc._y + m_mask_mc._height - m_content_mc._height;
				m_newYPosition = m_mask_mc._y + m_mask_mc._height - m_content_mc._height;
			} else {
				//m_content_mc._y += delta;
				m_newYPosition = m_content_mc._y + delta;
			}
		}
		m_content_mc._y = m_newYPosition;
		
		// Posición barra scroll
		m_verticalBar_mc._y = m_y + m_barWidth + ((m_mask_mc._y - m_content_mc._y)/(m_content_mc._height- m_mask_mc._height)*(m_height-2*m_barWidth-m_verticalBar_mc._height));
		
	}
	
	/**
	 * moveh(delta)<br>
	 * <p>Desplaza el contenido del scroll una cantidad <pre>delta</pre>.</p>
	 * 
	 * @param delta Cantidad de píxeles que se va a desplazar el contenido del scroll. Dependiendo
	 * del signo que tenga se moverá hacia la derecha o hacia la izquierda
	 */
	private function moveh(delta: Number): Void {
		
		// Mover el contenido
		if (delta > 0) { // leftArrow
			if ((m_content_mc._x + delta) > m_mask_mc._x) {
				m_content_mc._x = m_mask_mc._x;
			} else {
				m_content_mc._x += delta;
			}
		} else { // rightArrow
			if ((m_content_mc._x + m_content_mc._width + delta) < (m_mask_mc._x + m_mask_mc._width)) {
				m_content_mc._x = m_mask_mc._x + m_mask_mc._width - m_content_mc._width;
			} else {
				m_content_mc._x += delta;
			}
		}
		
		// Posición barra scroll
		m_horizontalBar_mc._x = m_x + m_barWidth + ((m_mask_mc._x - m_content_mc._x)/(m_content_mc._width-m_mask_mc._width)*(m_width-2*m_barWidth-m_horizontalBar_mc._width));
		
	}
	
	/**
	 * moveUp()<br>
	 * <p>Desplaza el scroll cuando se pulsa <pre>m_upArrow_mc</pre>. El contenido se mueve hacia
	 * abajo.</p>
	 */
	private function moveUp(): Void {
		
		this.movev(m_increase);
		
	}
	
	/**
	 * moveDown()<br>
	 * <p>Desplaza el scroll cuando se pulsa <pre>m_downArrow_mc</pre>. El contenido se mueve hacia
	 * arriba.</p>
	 */
	private function moveDown(): Void {
		
		this.movev(m_increase * (-1));
		
	}
	
	/**
	 * moveLeft()<br>
	 * <p>Desplaza el scroll cuando se pulsa <pre>m_leftArrow_mc</pre>. El contenido se mueve hacia
	 * la derecha.</p>
	 */
	private function moveLeft(): Void {
		
		this.moveh(m_increase);
		
	}
	
	/**
	 * moveRight()<br>
	 * <p>Desplaza el scroll cuando se pulsa <pre>m_rightArrow_mc</pre>. El contenido se mueve 
	 * hacia la izquierda.</p>
	 */
	private function moveRight(): Void {
		
		this.moveh(m_increase * (-1));
		
	}
	
	/**
	 * moveByVerticalBar()<br>
	 * <p>Mueve el contenido del scroll según la posición de la barra de scroll. La función se
	 * ejecuta cuando se hace el drag de <pre>m_verticalBar_mc</pre>.</p>
	 */
	private function moveByVerticalBar(): Void {
		
		var newPosition: Number = (-1) * ((m_verticalBar_mc._y-m_y-m_barWidth)/(m_height-2*m_barWidth-m_verticalBar_mc._height)*(m_content_mc._height-m_mask_mc._height)-m_mask_mc._y);
		
		if (!m_easing) {
			m_content_mc._y = newPosition;
		} else {
			m_oldYPosition = m_content_mc._y;
			m_newYPosition = newPosition;
			m_tweenY = new Tween(m_content_mc, "_y", Regular.easeOut, m_oldYPosition, m_newYPosition, 1, true);
		}
		
	}
	
	/**
	 * moveByHorizontalBar()<br>
	 * <p>Mueve el contenido del scroll según la posición de la barra de scroll. La función se
	 * ejecuta cuando se hace el drag de <pre>m_horizontalBar_mc</pre>.</p>
	 */
	private function moveByHorizontalBar(): Void {
		
		var newPosition: Number = (-1) * ((m_horizontalBar_mc._x-m_x-m_barWidth)/(m_width-2*m_barWidth-m_horizontalBar_mc._width)*(m_content_mc._width-m_mask_mc._width)-m_mask_mc._x);
		
		if (!m_easing) { 
			m_content_mc._x = newPosition;
		} else {
			m_oldXPosition = m_content_mc._x;
			m_newXPosition = newPosition;
			m_tweenX = new Tween(m_content_mc, "_x", Regular.easeOut, m_oldXPosition, m_newXPosition, 1, true);
		}
		
	}
	
	
	///// EVENTS //////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * __upArrowPressed()<br>
	 * <p>Acciones a realizar cuando se pulsa el MC <pre>m_upArrow_mc</pre>.</p>
	 */
	private function __upArrowPressed(): Void {
		
		this.moveUp();
		m_idInterval = setInterval(this, "moveUp", 1000/m_speed);
		
	}
	
	/**
	 * __upArrowReleased()<br>
	 * <p>Acciones a realizar cuando se suelta el MC <pre>m_upArrow_mc</pre>.</p>
	 */
	private function __upArrowReleased(): Void {
		
		clearInterval(m_idInterval);
		
	}
	
	/**
	 * __downArrowPressed()<br>
	 * <p>Acciones a realizar cuando se pulsa el MC <pre>m_downArrow_mc</pre>.</p>
	 */
	private function __downArrowPressed(): Void {
		
		this.moveDown();
		m_idInterval = setInterval(this, "moveDown", 1000/m_speed);
		
	}
	
	/**
	 * __downArrowReleased()<br>
	 * <p>Acciones a realizar cuando se suelta el MC <pre>m_upArrow_mc</pre>.</p>
	 */
	private function __downArrowReleased(): Void {
		
		clearInterval(m_idInterval);
		
	}
	
	/**
	 * __leftArrowPressed()<br>
	 * <p>Acciones a realizar cuando se pulsa el MC <pre>m_leftArrow_mc</pre>.</p>
	 */
	private function __leftArrowPressed(): Void {
		
		this.moveLeft();
		m_idInterval = setInterval(this, "moveLeft", 1000/m_speed);
		
	}
	
	/**
	 * __leftArrowReleased()<br>
	 * <p>Acciones a realizar cuando se suelta el MC <pre>m_leftArrow_mc</pre>.</p>
	 */
	private function __leftArrowReleased(): Void {
		
		clearInterval(m_idInterval);
		
	}
	
	/**
	 * __rightArrowPressed()<br>
	 * <p>Acciones a realizar cuando se pulsa el MC <pre>m_rightArrow_mc</pre>.</p>
	 */
	private function __rightArrowPressed(): Void {
		
		this.moveRight();
		m_idInterval = setInterval(this, "moveRight", 1000/m_speed);
		
	}
	
	/**
	 * __rightArrowReleased()<br>
	 * <p>Acciones a realizar cuando se suelta el MC <pre>m_rightArrow_mc</pre>.</p>
	 */
	private function __rightArrowReleased(): Void {
		
		clearInterval(m_idInterval);
		
	}
	
	/**
	 * __verticalBarPressed()<br>
	 * <p>Acciones a realizar cuando se pulsa el MC <pre>m_verticalBar_mc</pre>.</p>
	 */
	private function __verticalBarPressed(): Void {
		
		m_verticalBar_mc.startDrag(false, m_x + m_width, m_y + m_barWidth, m_x + m_width, m_y + m_height - m_barWidth - m_verticalBar_mc._height);
		m_idInterval = setInterval(this, "moveByVerticalBar", 1000/m_speed);
		
	}
	
	/**
	 * __verticalBarReleased()<br>
	 * <p>Acciones a realizar cuando se suelta el MC <pre>m_verticalBar_mc</pre>.</p>
	 */
	private function __verticalBarReleased(): Void {
		
		m_verticalBar_mc.stopDrag();
		clearInterval(m_idInterval);
		
	}
	
	/**
	 * __horizontalBarPressed()<br>
	 * <p>Acciones a realizar cuando se pulsa el MC <pre>m_horizontalBar_mc</pre>.</p>
	 */
	private function __horizontalBarPressed(): Void {
		
		m_horizontalBar_mc.startDrag(false, m_x + m_barWidth, m_y + m_height, m_x + m_width - m_barWidth - m_horizontalBar_mc._width, m_y + m_height);
		m_idInterval = setInterval(this, "moveByHorizontalBar", 1000/m_speed);
		
	}
	
	/**
	 * __horizontalBarReleased()<br>
	 * <p>Acciones a realizar cuando se suelta el MC <pre>m_horizontalBar_mc</pre>.</p>
	 */
	private function __horizontalBarReleased(): Void {
		
		m_horizontalBar_mc.stopDrag();
		clearInterval(m_idInterval);
		
	}
	
} // end class