function [fitresult, gof] = createFit2(x, data_col)
%CREATEFIT2(X,DATA_COL)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: data_col
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 09-Apr-2019 09:59:58


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, data_col );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'smoothingspline');
opts.SmoothingParam = 0.555;

% smoothingspline pchipinterp poly8

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );



% opts = fitoptions('gauss4', 'Lower', [0 -Inf 0 0 -Inf 0]);
% opts.Lower = [0 -Inf 0 0 -Inf 0];
% 
% ft = fittype( 'gauss4' );
% [fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'data_col vs. x', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel x
% ylabel data_col
% grid on
% hold on

