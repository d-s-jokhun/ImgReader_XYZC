
%%% written by D.S.JOKHUN on 10/04/2015

% Ch corresponds to the channels that have to be read. [] or 0 will cause 
% the function to read all the channels.
% Z corresponds to the z slices that have to be read. [] or 0 will cause 
% the function to read all the z slices.



function Image=ImgReader_XYZC(Filename,Z,C)

script_path=matlab.desktop.editor.getActiveFilename;
path = extractBetween(script_path,1,'\ImgReader_XYZC.m');
path = genpath(path);
addpath(string(path));

Reader = bfGetReader (Filename);
OmeMeta = Reader.getMetadataStore();

MetaData.Num_of_Ch = OmeMeta.getPixelsSizeC(0).getValue();
MetaData.Num_of_Pixels_Z = OmeMeta.getPixelsSizeZ(0).getValue();
MetaData.Num_of_Pixels_X = OmeMeta.getPixelsSizeX(0).getValue();
MetaData.Num_of_Pixels_Y = OmeMeta.getPixelsSizeY(0).getValue();
MetaData.Voxel_Size_X = double(OmeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROM)); % in µm
MetaData.Voxel_Size_Y = double(OmeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROM)); % in µm
MetaData.Voxel_Size_Z = double(OmeMeta.getPixelsPhysicalSizeZ(0).value(ome.units.UNITS.MICROM)); % in µm

Image=cell(MetaData.Num_of_Ch+1,1);
Image{end}=MetaData;

iSeries = 1;
iT=1;

Reader.setSeries(iSeries - 1);


if ~exist('Ch','var')
    C=1:MetaData.Num_of_Ch;
else
    if numel(nonzeros(C))<1
        C=1:MetaData.Num_of_Ch;
    end
end
if ~exist('Z','var')
    Z=1:MetaData.Num_of_Pixels_Z;
else
    if numel(nonzeros(Z))<1
        Z=1:MetaData.Num_of_Pixels_Z;
    end
end



for iCh=C
    XYZ_temp =uint16([]);
    for iZ=Z
        iPlane = Reader.getIndex(iZ-1, iCh-1, iT-1) + 1;   
        XYZ_temp(:,:,iZ)= bfGetPlane(Reader, iPlane);
    end
    Image{iCh}=XYZ_temp;   
end



end




%% load planes using plane index
%Reader.setSeries (5)
%iPlane = plane of interest
%I = bfGetPlane(Reader, iPlane);

%% subject = OmeMeta.get+"Subject"(0).getvalue();   %to get anything from the metadata
% list of possible subjects can be found at:
% http://downloads.openmicroscopy.org/bio-formats/5.1.0/api/loci/formats/meta/MetadataRetrieve.html