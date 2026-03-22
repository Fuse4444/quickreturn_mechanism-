function quickReturnGUI()

    %% COLOUR PALETTE
    clrBg     = [0.13 0.14 0.17];
    clrPanel  = [0.18 0.20 0.24];
    clrBorder = [0.28 0.32 0.38];
    clrAccent = [0.20 0.60 1.00];
    clrText   = [0.92 0.93 0.95];
    clrMuted  = [0.55 0.60 0.65];
    clrAxBg   = [0.10 0.11 0.14];
    clrGreen  = [0.18 0.82 0.49];

    %% FIGURE
    % Layout constants
    FW = 1440; FH = 820;   % figure width / height
    PW = 260;              % left panel width (content area: 16..244)
    M  = 16;               % outer margin
    G  = 10;               % gap between panels

    fig = uifigure('Name','Quick Return Mechanism Analyser',...
        'Position',[40 30 FW FH],...
        'Color', clrBg);

    %% LEFT PANEL  (x:M, y:M, w:PW-2*M, h:FH-2*M)
    panW = PW - M;   % 244
    uipanel(fig,...
        'Position',[M M panW (FH-2*M)],...
        'BackgroundColor', clrPanel,...
        'BorderType','line',...
        'HighlightColor', clrBorder,...
        'BorderWidth',1);

    % field right-edge = panW-M = 228, field width = 90, so x = 138
    fX = 138; fW = panW - fX - M;   % fX=138, fW=90  => right edge=244-16=228 ✓

    % --- helpers ---
    function lbl = mkLabel(x, y, w, txt)
        lbl = uilabel(fig,'Position',[x y w 18],...
            'Text',txt,'FontName','Helvetica Neue','FontSize',10,...
            'FontColor',clrMuted,'HorizontalAlignment','left');
    end

    function fld = mkField(x, y, val)
        fld = uieditfield(fig,'numeric','Position',[x y fW 24],...
            'Value',val,'FontName','Helvetica Neue','FontSize',11,...
            'FontColor',clrText,'BackgroundColor',clrBg,...
            'HorizontalAlignment','center');
    end

    function ax = mkAx(x, y, w, h, ttl)
        ax = uiaxes(fig,'Position',[x y w h]);
        ax.Color           = clrAxBg;
        ax.XColor          = clrMuted;
        ax.YColor          = clrMuted;
        ax.GridColor       = clrBorder;
        ax.MinorGridColor  = clrBorder;
        ax.XGrid           = 'on';
        ax.YGrid           = 'on';
        ax.GridAlpha       = 0.35;
        ax.FontName        = 'Helvetica Neue';
        ax.FontSize        = 9;
        ax.TitleFontSizeMultiplier = 1.0;
        title(ax, ttl, 'Color',clrText,'FontWeight','bold','FontSize',10);
        ax.XLabel.Color    = clrMuted;
        ax.YLabel.Color    = clrMuted;
    end

    function divider(y)
        uipanel(fig,'Position',[M+8 y panW-16 1],...
            'BackgroundColor',clrBorder,'BorderType','none');
    end

    % --- INPUT PARAMETERS section ---
    uilabel(fig,'Position',[M+8 FH-46 panW-16 20],...
        'Text','INPUT PARAMETERS',...
        'FontName','Helvetica Neue','FontSize',10,'FontWeight','bold',...
        'FontColor',clrAccent,'HorizontalAlignment','left');

    rowY = FH - 80;  % first row top
    rowH = 38;       % row spacing

    mkLabel(M+8, rowY,      110, 'QRR');
    qrrField = mkField(fX, rowY-3, 1.5);

    mkLabel(M+8, rowY-rowH,   110, 'Phi (deg)');
    phiField = mkField(fX, rowY-rowH-3, 60);

    mkLabel(M+8, rowY-2*rowH, 110, 'L4');
    l4Field  = mkField(fX, rowY-2*rowH-3, 1);

    mkLabel(M+8, rowY-3*rowH, 110, 'Design angle');
    dirField = mkField(fX, rowY-3*rowH-3, 15);

    divider(rowY - 3*rowH - 20);

    runBtn = uibutton(fig,'push','Text','▶   RUN',...
        'Position',[M+8 rowY-3*rowH-60 panW-16 34],...
        'FontName','Helvetica Neue','FontSize',12,'FontWeight','bold',...
        'FontColor',[0.04 0.04 0.04],'BackgroundColor',clrGreen);

    divider(rowY - 3*rowH - 72);

    uilabel(fig,'Position',[M+8 rowY-3*rowH-92 110 18],...
        'Text','ω₂  Speed',...
        'FontName','Helvetica Neue','FontSize',10,'FontColor',clrMuted);

    omegaSlider = uislider(fig,...
        'Position',[M+8 rowY-3*rowH-112 panW-16 3],...
        'Limits',[0.1 20],'Value',1,...
        'MajorTicks',[],'MinorTicks',[]);

    divider(rowY - 3*rowH - 124);

    uilabel(fig,'Position',[M+8 rowY-3*rowH-144 panW-16 18],...
        'Text','COMPUTED PARAMETERS',...
        'FontName','Helvetica Neue','FontSize',9,'FontWeight','bold',...
        'FontColor',clrAccent);

    paramLabel = uilabel(fig,...
        'Position',[M+8 M+10 panW-16 rowY-3*rowH-174],...
        'Text','— run to compute —',...
        'HorizontalAlignment','left','VerticalAlignment','top',...
        'FontName','Courier New','FontSize',11,...
        'FontColor',clrText,'BackgroundColor',clrBg,...
        'WordWrap','on');

    %% AXES LAYOUT
    % Total plot area: x from PW+G to FW-M  => width = FW-M-PW-G = 1440-16-260-10 = 1154
    % Split horizontally: col1=480 (axAnim+axTime), col2=330 (axConstruct+axOmega), col3=330 (axTheta)
    % Gap between columns = 7
    x1 = PW + G;          % 270
    cw1 = 480;            % mechanism column — wide
    x2 = x1 + cw1 + G;   % 757
    cw2 = 326;
    x3 = x2 + cw2 + G;   % 1090
    cw3 = FW - M - x3;   % 334

    % Row heights: top row = FH*0.52, bottom = remainder minus margins
    topH = round(FH * 0.52);   % ~426
    botH = FH - 2*M - topH - G; % ~350

    axAnim      = mkAx(x1, M+botH+G, cw1, topH,  'Mechanism');
    axTime      = mkAx(x1, M,        cw1, botH,   '\theta_4  vs  Time');

    axConstruct = mkAx(x2, M+botH+G, cw2, topH,  'Construction Geometry');
    axOmega     = mkAx(x2, M,        cw2, botH,   '\omega_4  vs  \theta_4');

    axTheta     = mkAx(x3, M+botH+G, cw3, topH,  '\theta_2  vs  \theta_4');

    runBtn.ButtonPushedFcn = @(~,~) runSimulation();

    %% ================================
    function runSimulation()

        QRR       = qrrField.Value;
        phi_deg   = phiField.Value;
        l4        = l4Field.Value;
        dir_angle = dirField.Value;

        %% SYNTHESIS
        mech = quickReturnSynthesis(QRR, phi_deg, l4, dir_angle);

        l1 = mech.l1; l2 = mech.l2; l3 = mech.l3; l4 = mech.l4;
        O2 = mech.O2; O4 = mech.O4;

        % Compute Freudenstein constants and display in GUI
        K1 = l1/l2;
        K2 = l1/l4;
        K3 = (l2^2 - l3^2 + l4^2 + l1^2)/(2*l2*l4);

        paramLabel.Text = sprintf([ ...
            'l1 = %.3f\nl2 = %.3f\nl3 = %.3f\nl4 = %.3f\n\n' ...
            'K1 = %.3f\nK2 = %.3f\nK3 = %.3f'], ...
            l1, l2, l3, l4, K1, K2, K3);

        %% CONSTRUCTION GEOMETRY PLOT
        B1_c    = mech.B1;
        B2_c    = mech.B2;
        dir_X_c = mech.dir_X;
        dir_Y_c = mech.dir_Y;
        O2_c    = mech.O2;
        O4_c    = mech.O4;

        cla(axConstruct); hold(axConstruct,'on'); axis(axConstruct,'equal');

        scale = max(norm(O2_c - O4_c), 1.5) * 1.2;

        % XX' line through B1 (red dashed)
        X_line = [B1_c - scale*dir_X_c; B1_c + scale*dir_X_c];
        plot(axConstruct, X_line(:,1), X_line(:,2), 'r--', 'LineWidth', 1.5);

        % YY' line through B2 (blue dashed)
        Y_line = [B2_c - scale*dir_Y_c; B2_c + scale*dir_Y_c];
        plot(axConstruct, Y_line(:,1), Y_line(:,2), 'b--', 'LineWidth', 1.5);

        % Points
        plot(axConstruct, B1_c(1), B1_c(2), 'ro', 'MarkerFaceColor','r',  'MarkerSize',7);
        plot(axConstruct, B2_c(1), B2_c(2), 'bo', 'MarkerFaceColor','b',  'MarkerSize',7);
        plot(axConstruct, O2_c(1), O2_c(2), 'ko', 'MarkerFaceColor','k',  'MarkerSize',7);
        plot(axConstruct, O4_c(1), O4_c(2), 'go', 'MarkerFaceColor','g',  'MarkerSize',7);

        % Labels
        text(axConstruct, B1_c(1), B1_c(2), '  B1', 'Color','r');
        text(axConstruct, B2_c(1), B2_c(2), '  B2', 'Color','b');
        text(axConstruct, O2_c(1), O2_c(2), '  O2', 'Color','k');
        text(axConstruct, O4_c(1), O4_c(2), '  O4', 'Color','g');

        % Legend entries
        legend(axConstruct, "XX'", "YY'", 'Location','best');

        title(axConstruct, sprintf('Construction  |  \\alpha = %.1f°', rad2deg(mech.alpha)));

        ax_pad = scale * 1.1;
        xlim(axConstruct, [-ax_pad ax_pad]);
        ylim(axConstruct, [-ax_pad ax_pad]);

        drawnow;

        %% FRAME TRANSFORM
        shift = -O2;
        O4 = O4 + shift;
        theta_align = atan2(O4(2), O4(1));

        R = [cos(-theta_align), -sin(-theta_align);
             sin(-theta_align),  cos(-theta_align)];

        O4 = (R * O4')';
        O2 = [0,0];

        %% SIMULATION
        theta2     = 0;
        t          = 0;
        dt         = 0.01;
        t_vals     = [];
        dtheta_base = 0.02;
        theta2_vals = [];
        theta4_vals = [];
        omega4_vals = [];

        omega2 = max(0.1, omegaSlider.Value);

        prev_theta4 = 0;

        cla(axTheta); cla(axOmega); cla(axTime);

        %% LOOP
        i = 1;
        while true

            t = t + dt;
            t_vals(end+1) = t;

            dtheta = dtheta_base * omegaSlider.Value;
            theta2 = theta2 + dtheta;

            if i == 1
                prev_theta4 = 0;
            end

            % Freudenstein solve
            A_f = cos(theta2) - K1 - K2*cos(theta2) + K3;
            B_f = -2*sin(theta2);
            C_f = K1 - (K2+1)*cos(theta2) + K3;

            D = B_f^2 - 4*A_f*C_f;

            if D < 0 || abs(A_f) < 1e-6
                i = i + 1;
                continue;
            end

            t1 = (-B_f + sqrt(D))/(2*A_f);
            t2 = (-B_f - sqrt(D))/(2*A_f);

            theta4_1 = 2*atan(t1);
            theta4_2 = 2*atan(t2);

            % Choose closest branch
            if abs(theta4_1 - prev_theta4) < abs(theta4_2 - prev_theta4)
                theta4 = theta4_1;
            else
                theta4 = theta4_2;
            end

            % Continuity correction
            theta4 = unwrap([prev_theta4 theta4]);
            theta4 = theta4(2);
            prev_theta4 = theta4;

            theta2_vals(end+1) = theta2;
            theta4_vals(end+1) = theta4;
            omega4_vals(end+1) = NaN;

            % theta3
            A_pos = [l2*cos(theta2), l2*sin(theta2)];
            B_pos = [l1 + l4*cos(theta4), l4*sin(theta4)];
            theta3 = atan2(B_pos(2)-A_pos(2), B_pos(1)-A_pos(1));

            % omega4 (finite difference)
            if length(theta4_vals) > 1
                dtheta4 = wrapToPi(theta4_vals(end) - theta4_vals(end-1));
                dtheta2_step = theta2_vals(end) - theta2_vals(end-1);
                omega4_vals(end) = omega2 * (dtheta4 / dtheta2_step);
            end

            % Joint positions
            A_pt = [l2*cos(theta2), l2*sin(theta2)];
            B_pt = A_pt + [l3*cos(theta3), l3*sin(theta3)];

            % --- Animation ---
            cla(axAnim); hold(axAnim,'on'); axis(axAnim,'equal');

            % Links
            plot(axAnim,[O2(1) A_pt(1)],[O2(2) A_pt(2)],'r','LineWidth',2);
            plot(axAnim,[A_pt(1) B_pt(1)],[A_pt(2) B_pt(2)],'g','LineWidth',2);
            plot(axAnim,[B_pt(1) O4(1)],[B_pt(2) O4(2)],'b','LineWidth',2);
            plot(axAnim,[O2(1) O4(1)],[O2(2) O4(2)],'w','LineWidth',2);

            % Joints
            plot(axAnim,O2(1),O2(2),'ko','MarkerFaceColor','w');
            plot(axAnim,O4(1),O4(2),'ko','MarkerFaceColor','w');
            plot(axAnim,A_pt(1),A_pt(2),'ro','MarkerFaceColor','r');
            plot(axAnim,B_pt(1),B_pt(2),'bo','MarkerFaceColor','y');

            % Labels
            text(axAnim,O2(1),O2(2),'  O2');
            text(axAnim,O4(1),O4(2),'  O4');
            text(axAnim,A_pt(1),A_pt(2),'  A');
            text(axAnim,B_pt(1),B_pt(2),'  B');

            % Link labels at midpoints
            mid_O2A  = (O2 + A_pt)/2;
            mid_AB   = (A_pt + B_pt)/2;
            mid_BO4  = (B_pt + O4)/2;
            mid_O2O4 = (O2 + O4)/2;

            text(axAnim,mid_O2A(1), mid_O2A(2), ' l2','Color','r');
            text(axAnim,mid_AB(1),  mid_AB(2),  ' l3','Color','g');
            text(axAnim,mid_BO4(1), mid_BO4(2), ' l4','Color','b');
            text(axAnim,mid_O2O4(1),mid_O2O4(2),' l1','Color','y');

            xlim(axAnim,[-2*l1 2*l1]);
            ylim(axAnim,[-2*l1 2*l1]);

            drawnow;

            % Plots
            plot(axTheta,theta2_vals,theta4_vals,'r'); hold(axTheta,'on');
            plot(axOmega,theta4_vals,omega4_vals,'b'); hold(axOmega,'on');
            plot(axTime, t_vals, theta4_vals, 'y');    hold(axTime,'on');

            pause(0.01);
            i = i + 1;
        end

    end

end

%% ================================
function mech = quickReturnSynthesis(QRR, phi_deg, l4, dir_angle_deg)

    if nargin < 4
        dir_angle_deg = 0;
    end

    phi   = deg2rad(phi_deg);
    alpha = deg2rad(180 * (QRR - 1)/(QRR + 1));

    O4 = [0, 0];

    B1 = [ l4*sin(phi/2),  l4*cos(phi/2)];
    B2 = [-l4*sin(phi/2),  l4*cos(phi/2)];

    theta = deg2rad(dir_angle_deg);
    dir_X = [cos(theta), sin(theta)];

    R = [cos(alpha), -sin(alpha);
         sin(alpha),  cos(alpha)];

    dir_Y = (R * dir_X')';

    A_sys = [dir_X', -dir_Y'];
    b_sys = (B2 - B1)';

    if rank(A_sys) < 2
        error('Invalid geometry: lines parallel');
    end

    ts = A_sys \ b_sys;
    O2 = B1 + ts(1)*dir_X;

    d1 = norm(O2 - B1);
    d2 = norm(O2 - B2);

    l3 = (d1 + d2)/2;
    l2 = (d1 - d2)/2;
    l1 = norm(O2 - O4);

    mech.l1    = l1;
    mech.l2    = l2;
    mech.l3    = l3;
    mech.l4    = l4;
    mech.O2    = O2;
    mech.O4    = O4;
    mech.B1    = B1;
    mech.B2    = B2;
    mech.dir_X = dir_X;
    mech.dir_Y = dir_Y;
    mech.alpha = alpha;

end