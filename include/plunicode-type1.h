/*
 * This header file contains the lookup tables used for converting between
 * unicode and the 3 standard type 1 font sequences, dingbats, standard, and
 * symbol.  These data therefore allow unicode access to at least the 35
 * standard type 1 fonts in the gsfonts font package, and probably many other
 * type 1 fonts as well.
 *
 * Copyright (C) 2005  Alan W. Irwin
 *
 * This file is part of PLplot.
 *
 * PLplot is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Library Public License as published
 * by the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * PLplot is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with PLplot; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

typedef struct
{
    PLUNICODE     Unicode;
    unsigned char Type1;
} Unicode_to_Type1_table;

static const int                    number_of_entries_in_unicode_to_dingbats_table = 188;

static const Unicode_to_Type1_table unicode_to_dingbats_lookup_table[188] = {
    { 0x0020,  32 },
    { 0x2192, 213 },
    { 0x2194, 214 },
    { 0x2195, 215 },
    { 0x2460, 172 },
    { 0x2461, 173 },
    { 0x2462, 174 },
    { 0x2463, 175 },
    { 0x2464, 176 },
    { 0x2465, 177 },
    { 0x2466, 178 },
    { 0x2467, 179 },
    { 0x2468, 180 },
    { 0x2469, 181 },
    { 0x25a0, 110 },
    { 0x25b2, 115 },
    { 0x25bc, 116 },
    { 0x25c6, 117 },
    { 0x25cf, 108 },
    { 0x25d7, 119 },
    { 0x2605,  72 },
    { 0x260e,  37 },
    { 0x261b,  42 },
    { 0x261e,  43 },
    { 0x2660, 171 },
    { 0x2663, 168 },
    { 0x2665, 170 },
    { 0x2666, 169 },
    { 0x2701,  33 },
    { 0x2702,  34 },
    { 0x2703,  35 },
    { 0x2704,  36 },
    { 0x2706,  38 },
    { 0x2707,  39 },
    { 0x2708,  40 },
    { 0x2709,  41 },
    { 0x270c,  44 },
    { 0x270d,  45 },
    { 0x270e,  46 },
    { 0x270f,  47 },
    { 0x2710,  48 },
    { 0x2711,  49 },
    { 0x2712,  50 },
    { 0x2713,  51 },
    { 0x2714,  52 },
    { 0x2715,  53 },
    { 0x2716,  54 },
    { 0x2717,  55 },
    { 0x2718,  56 },
    { 0x2719,  57 },
    { 0x271a,  58 },
    { 0x271b,  59 },
    { 0x271c,  60 },
    { 0x271d,  61 },
    { 0x271e,  62 },
    { 0x271f,  63 },
    { 0x2720,  64 },
    { 0x2721,  65 },
    { 0x2722,  66 },
    { 0x2723,  67 },
    { 0x2724,  68 },
    { 0x2725,  69 },
    { 0x2726,  70 },
    { 0x2727,  71 },
    { 0x2729,  73 },
    { 0x272a,  74 },
    { 0x272b,  75 },
    { 0x272c,  76 },
    { 0x272d,  77 },
    { 0x272e,  78 },
    { 0x272f,  79 },
    { 0x2730,  80 },
    { 0x2731,  81 },
    { 0x2732,  82 },
    { 0x2733,  83 },
    { 0x2734,  84 },
    { 0x2735,  85 },
    { 0x2736,  86 },
    { 0x2737,  87 },
    { 0x2738,  88 },
    { 0x2739,  89 },
    { 0x273a,  90 },
    { 0x273b,  91 },
    { 0x273c,  92 },
    { 0x273d,  93 },
    { 0x273e,  94 },
    { 0x273f,  95 },
    { 0x2740,  96 },
    { 0x2741,  97 },
    { 0x2742,  98 },
    { 0x2743,  99 },
    { 0x2744, 100 },
    { 0x2745, 101 },
    { 0x2746, 102 },
    { 0x2747, 103 },
    { 0x2748, 104 },
    { 0x2749, 105 },
    { 0x274a, 106 },
    { 0x274b, 107 },
    { 0x274d, 109 },
    { 0x274f, 111 },
    { 0x2750, 112 },
    { 0x2751, 113 },
    { 0x2752, 114 },
    { 0x2756, 118 },
    { 0x2758, 120 },
    { 0x2759, 121 },
    { 0x275a, 122 },
    { 0x275b, 123 },
    { 0x275c, 124 },
    { 0x275d, 125 },
    { 0x275e, 126 },
    { 0x2761, 161 },
    { 0x2762, 162 },
    { 0x2763, 163 },
    { 0x2764, 164 },
    { 0x2765, 165 },
    { 0x2766, 166 },
    { 0x2767, 167 },
    { 0x2776, 182 },
    { 0x2777, 183 },
    { 0x2778, 184 },
    { 0x2779, 185 },
    { 0x277a, 186 },
    { 0x277b, 187 },
    { 0x277c, 188 },
    { 0x277d, 189 },
    { 0x277e, 190 },
    { 0x277f, 191 },
    { 0x2780, 192 },
    { 0x2781, 193 },
    { 0x2782, 194 },
    { 0x2783, 195 },
    { 0x2784, 196 },
    { 0x2785, 197 },
    { 0x2786, 198 },
    { 0x2787, 199 },
    { 0x2788, 200 },
    { 0x2789, 201 },
    { 0x278a, 202 },
    { 0x278b, 203 },
    { 0x278c, 204 },
    { 0x278d, 205 },
    { 0x278e, 206 },
    { 0x278f, 207 },
    { 0x2790, 208 },
    { 0x2791, 209 },
    { 0x2792, 210 },
    { 0x2793, 211 },
    { 0x2794, 212 },
    { 0x2798, 216 },
    { 0x2799, 217 },
    { 0x279a, 218 },
    { 0x279b, 219 },
    { 0x279c, 220 },
    { 0x279d, 221 },
    { 0x279e, 222 },
    { 0x279f, 223 },
    { 0x27a0, 224 },
    { 0x27a1, 225 },
    { 0x27a2, 226 },
    { 0x27a3, 227 },
    { 0x27a4, 228 },
    { 0x27a5, 229 },
    { 0x27a6, 230 },
    { 0x27a7, 231 },
    { 0x27a8, 232 },
    { 0x27a9, 233 },
    { 0x27aa, 234 },
    { 0x27ab, 235 },
    { 0x27ac, 236 },
    { 0x27ad, 237 },
    { 0x27ae, 238 },
    { 0x27af, 239 },
    { 0x27b1, 241 },
    { 0x27b2, 242 },
    { 0x27b3, 243 },
    { 0x27b4, 244 },
    { 0x27b5, 245 },
    { 0x27b6, 246 },
    { 0x27b7, 247 },
    { 0x27b8, 248 },
    { 0x27b9, 249 },
    { 0x27ba, 250 },
    { 0x27bb, 251 },
    { 0x27bc, 252 },
    { 0x27bd, 253 },
    { 0x27be, 254 }
};

static const int                    number_of_entries_in_unicode_to_standard_table = 149;

static const Unicode_to_Type1_table unicode_to_standard_lookup_table[149] = {
    { 0x0020,  32 },
    { 0x0021,  33 },
    { 0x0022,  34 },
    { 0x0023,  35 },
    { 0x0024,  36 },
    { 0x0025,  37 },
    { 0x0026,  38 },
    { 0x0027,  39 },
    { 0x0028,  40 },
    { 0x0029,  41 },
    { 0x002a,  42 },
    { 0x002b,  43 },
    { 0x002c,  44 },
    { 0x002d,  45 },
    { 0x002e,  46 },
    { 0x002f,  47 },
    { 0x0030,  48 },
    { 0x0031,  49 },
    { 0x0032,  50 },
    { 0x0033,  51 },
    { 0x0034,  52 },
    { 0x0035,  53 },
    { 0x0036,  54 },
    { 0x0037,  55 },
    { 0x0038,  56 },
    { 0x0039,  57 },
    { 0x003a,  58 },
    { 0x003b,  59 },
    { 0x003c,  60 },
    { 0x003d,  61 },
    { 0x003e,  62 },
    { 0x003f,  63 },
    { 0x0040,  64 },
    { 0x0041,  65 },
    { 0x0042,  66 },
    { 0x0043,  67 },
    { 0x0044,  68 },
    { 0x0045,  69 },
    { 0x0046,  70 },
    { 0x0047,  71 },
    { 0x0048,  72 },
    { 0x0049,  73 },
    { 0x004a,  74 },
    { 0x004b,  75 },
    { 0x004c,  76 },
    { 0x004d,  77 },
    { 0x004e,  78 },
    { 0x004f,  79 },
    { 0x0050,  80 },
    { 0x0051,  81 },
    { 0x0052,  82 },
    { 0x0053,  83 },
    { 0x0054,  84 },
    { 0x0055,  85 },
    { 0x0056,  86 },
    { 0x0057,  87 },
    { 0x0058,  88 },
    { 0x0059,  89 },
    { 0x005a,  90 },
    { 0x005b,  91 },
    { 0x005c,  92 },
    { 0x005d,  93 },
    { 0x005e,  94 },
    { 0x005f,  95 },
    { 0x0060, 193 },
    { 0x0061,  97 },
    { 0x0062,  98 },
    { 0x0063,  99 },
    { 0x0064, 100 },
    { 0x0065, 101 },
    { 0x0066, 102 },
    { 0x0067, 103 },
    { 0x0068, 104 },
    { 0x0069, 105 },
    { 0x006a, 106 },
    { 0x006b, 107 },
    { 0x006c, 108 },
    { 0x006d, 109 },
    { 0x006e, 110 },
    { 0x006f, 111 },
    { 0x0070, 112 },
    { 0x0071, 113 },
    { 0x0072, 114 },
    { 0x0073, 115 },
    { 0x0074, 116 },
    { 0x0075, 117 },
    { 0x0076, 118 },
    { 0x0077, 119 },
    { 0x0078, 120 },
    { 0x0079, 121 },
    { 0x007a, 122 },
    { 0x007b, 123 },
    { 0x007c, 124 },
    { 0x007d, 125 },
    { 0x007e, 126 },
    { 0x00a1, 161 },
    { 0x00a2, 162 },
    { 0x00a3, 163 },
    { 0x00a4, 168 },
    { 0x00a5, 165 },
    { 0x00a7, 167 },
    { 0x00a8, 200 },
    { 0x00aa, 227 },
    { 0x00ab, 171 },
    { 0x00af, 197 },
    { 0x00b4, 194 },
    { 0x00b6, 182 },
    { 0x00b7, 180 },
    { 0x00b8, 203 },
    { 0x00ba, 235 },
    { 0x00bb, 187 },
    { 0x00bf, 191 },
    { 0x00c6, 225 },
    { 0x00d8, 233 },
    { 0x00df, 251 },
    { 0x00e6, 241 },
    { 0x00f8, 249 },
    { 0x0131, 245 },
    { 0x0141, 232 },
    { 0x0142, 248 },
    { 0x0152, 234 },
    { 0x0153, 250 },
    { 0x0192, 166 },
    { 0x02c6, 195 },
    { 0x02c7, 207 },
    { 0x02d8, 198 },
    { 0x02d9, 199 },
    { 0x02da, 202 },
    { 0x02db, 206 },
    { 0x02dc, 196 },
    { 0x02dd, 205 },
    { 0x2013, 177 },
    { 0x2014, 208 },
    { 0x2018,  96 },
    { 0x2019,  39 },
    { 0x201a, 184 },
    { 0x201c, 170 },
    { 0x201d, 186 },
    { 0x201e, 185 },
    { 0x2020, 178 },
    { 0x2021, 179 },
    { 0x2022, 183 },
    { 0x2026, 188 },
    { 0x2030, 189 },
    { 0x2039, 172 },
    { 0x203a, 173 },
    { 0x2044, 164 },
    { 0xfb01, 174 },
    { 0xfb02, 175 }
};

static const int                    number_of_entries_in_unicode_to_symbol_table = 166;

static const Unicode_to_Type1_table unicode_to_symbol_lookup_table[166] = {
    { 0x0020,  32 },
    { 0x0021,  33 },
    { 0x0023,  35 },
    { 0x0025,  37 },
    { 0x0026,  38 },
    { 0x0028,  40 },
    { 0x0029,  41 },
    { 0x002b,  43 },
    { 0x002c,  44 },
    { 0x002e,  46 },
    { 0x002f,  47 },
    { 0x0030,  48 },
    { 0x0031,  49 },
    { 0x0032,  50 },
    { 0x0033,  51 },
    { 0x0034,  52 },
    { 0x0035,  53 },
    { 0x0036,  54 },
    { 0x0037,  55 },
    { 0x0038,  56 },
    { 0x0039,  57 },
    { 0x003a,  58 },
    { 0x003b,  59 },
    { 0x003c,  60 },
    { 0x003d,  61 },
    { 0x003e,  62 },
    { 0x003f,  63 },
    { 0x005b,  91 },
    { 0x005d,  93 },
    { 0x005f,  95 },
    { 0x007b, 123 },
    { 0x007c, 124 },
    { 0x007d, 125 },
    { 0x00a9, 211 },
    { 0x00ac, 216 },
    { 0x00ae, 210 },
    { 0x00b0, 176 },
    { 0x00b1, 177 },
    { 0x00d7, 180 },
    { 0x00f7, 184 },
    { 0x0192, 166 },
    { 0x0391,  65 },
    { 0x0392,  66 },
    { 0x0393,  71 },
    { 0x0394,  68 },
    { 0x0395,  69 },
    { 0x0396,  90 },
    { 0x0397,  72 },
    { 0x0398,  81 },
    { 0x0399,  73 },
    { 0x039a,  75 },
    { 0x039b,  76 },
    { 0x039c,  77 },
    { 0x039d,  78 },
    { 0x039e,  88 },
    { 0x039f,  79 },
    { 0x03a0,  80 },
    { 0x03a1,  82 },
    { 0x03a3,  83 },
    { 0x03a4,  84 },
    { 0x03a5,  85 },
    { 0x03a6,  70 },
    { 0x03a7,  67 },
    { 0x03a8,  89 },
    { 0x03a9,  87 },
    { 0x03b1,  97 },
    { 0x03b2,  98 },
    { 0x03b3, 103 },
    { 0x03b4, 100 },
    { 0x03b5, 101 },
    { 0x03b6, 122 },
    { 0x03b7, 104 },
    { 0x03b8, 113 },
    { 0x03b9, 105 },
    { 0x03ba, 107 },
    { 0x03bb, 108 },
    { 0x03bc, 109 },
    { 0x03bd, 110 },
    { 0x03be, 120 },
    { 0x03bf, 111 },
    { 0x03c0, 112 },
    { 0x03c1, 114 },
    { 0x03c2,  86 },
    { 0x03c3, 115 },
    { 0x03c4, 116 },
    { 0x03c5, 117 },
    { 0x03c6, 102 },
    { 0x03c7,  99 },
    { 0x03c8, 121 },
    { 0x03c9, 119 },
    { 0x03d1,  74 },
    { 0x03d2, 161 },
    { 0x03d5, 106 },
    { 0x03d6, 118 },
    { 0x2022, 183 },
    { 0x2026, 188 },
    { 0x2032, 162 },
    { 0x2033, 178 },
    { 0x203e,  96 },
    { 0x2044, 164 },
    { 0x2111, 193 },
    { 0x2118, 195 },
    { 0x211c, 194 },
    { 0x2122, 212 },
    { 0x2126,  87 },
    { 0x2135, 192 },
    { 0x2190, 172 },
    { 0x2191, 173 },
    { 0x2192, 174 },
    { 0x2193, 175 },
    { 0x2194, 171 },
    { 0x21b5, 191 },
    { 0x21d0, 220 },
    { 0x21d1, 221 },
    { 0x21d2, 222 },
    { 0x21d3, 223 },
    { 0x21d4, 219 },
    { 0x2200,  34 },
    { 0x2202, 182 },
    { 0x2203,  36 },
    { 0x2205, 198 },
    { 0x2206,  68 },
    { 0x2207, 209 },
    { 0x2208, 206 },
    { 0x2209, 207 },
    { 0x220b,  39 },
    { 0x220f, 213 },
    { 0x2211, 229 },
    { 0x2212,  45 },
    { 0x2215, 164 },
    { 0x2217,  42 },
    { 0x221a, 214 },
    { 0x221d, 181 },
    { 0x221e, 165 },
    { 0x2220, 208 },
    { 0x2227, 217 },
    { 0x2228, 218 },
    { 0x2229, 199 },
    { 0x222a, 200 },
    { 0x222b, 242 },
    { 0x2234,  92 },
    { 0x223c, 126 },
    { 0x2245,  64 },
    { 0x2248, 187 },
    { 0x2260, 185 },
    { 0x2261, 186 },
    { 0x2264, 163 },
    { 0x2265, 179 },
    { 0x2282, 204 },
    { 0x2283, 201 },
    { 0x2284, 203 },
    { 0x2286, 205 },
    { 0x2287, 202 },
    { 0x2295, 197 },
    { 0x2297, 196 },
    { 0x22a5,  94 },
    { 0x22c5, 215 },
    { 0x2320, 243 },
    { 0x2321, 245 },
    { 0x2329, 225 },
    { 0x232a, 241 },
    { 0x25ca, 224 },
    { 0x2660, 170 },
    { 0x2663, 167 },
    { 0x2665, 169 },
    { 0x2666, 168 }
};
